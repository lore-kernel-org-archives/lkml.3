Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaFJNeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:34:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:4952 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750936AbaFJNeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:34:02 -0400
Date: Tue, 10 Jun 2014 09:33:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140610093357.7ef3792b@gandalf.local.home>
In-Reply-To: <20140609140607.3e3aae39@gandalf.local.home>
References: <20140609140607.3e3aae39@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/yGIqms9mbjClKnAh63rNZ2d"
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/yGIqms9mbjClKnAh63rNZ2d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 9 Jun 2014 14:06:07 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> [ I'm currently running my tests on it now, and so far, after a few
>  hours it has yet to blow up. I'll run it for 24 hours which it never
>  succeeded in the past. ]

I ran with this patch on three boxes all night, one for 24 hours. No
problems. I stopped the tests, removed the patch, ran the test on the
same boxes and they all crashed within an hour.

This patch definitely fixes the bug.

The test I ran was:

while :; do
 ./ftrace-test-mkinstances || break
 ./ftrace-test-mkinstances-2 || break
done

Note, the tests expect debugfs to be mounted at /debug.

-- Steve

--MP_/yGIqms9mbjClKnAh63rNZ2d
Content-Type: application/octet-stream; name=ftrace-test-mkinstances
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=ftrace-test-mkinstances

IyEvYmluL2Jhc2gKCmlmIFsgISAtZCAvZGVidWcvdHJhY2luZy9pbnN0YW5jZXMgXTsgdGhlbgoJ
ZWNobyAiTm8gaW5zdGFuY2VzIGRpcmVjdG9yeSIKCWV4aXQgMApmaQoKY2QgL2RlYnVnL3RyYWNp
bmcvaW5zdGFuY2VzCgpta2RpciB4CnJtZGlyIHgKcmVzdWx0PSQ/CgppZiBbICRyZXN1bHQgLW5l
IDAgXTsgdGhlbgoJZWNobyAiaW5zdGFuY2Ugcm1kaXIgbm90IHN1cHBvcnRlZCwgc2tpcHBpbmcg
dGhpcyB0ZXN0IgoJZXhpdCAwCmZpCgppbnN0YW5jZV9zbGFtKCkgewoJd2hpbGUgOjsgZG8KCQlt
a2RpciB4CgkJbWtkaXIgeQoJCW1rZGlyIHoKCQlybWRpciB4CgkJcm1kaXIgeQoJCXJtZGlyIHoK
CWRvbmUgMj4vZGV2L251bGwKfQoKaW5zdGFuY2Vfc2xhbSAmCng9YGpvYnMgLWxgCnAxPWBlY2hv
ICR4IHwgY3V0IC1kJyAnIC1mMmAKZWNobyAkcDEKCmluc3RhbmNlX3NsYW0gJgp4PWBqb2JzIC1s
IHwgdGFpbCAtMWAKcDI9YGVjaG8gJHggfCBjdXQgLWQnICcgLWYyYAplY2hvICRwMgoKaW5zdGFu
Y2Vfc2xhbSAmCng9YGpvYnMgLWwgfCB0YWlsIC0xYApwMz1gZWNobyAkeCB8IGN1dCAtZCcgJyAt
ZjJgCmVjaG8gJHAzCgppbnN0YW5jZV9zbGFtICYKeD1gam9icyAtbCB8IHRhaWwgLTFgCnA0PWBl
Y2hvICR4IHwgY3V0IC1kJyAnIC1mMmAKZWNobyAkcDQKCmluc3RhbmNlX3NsYW0gJgp4PWBqb2Jz
IC1sIHwgdGFpbCAtMWAKcDU9YGVjaG8gJHggfCBjdXQgLWQnICcgLWYyYAplY2hvICRwNQoKZm9y
IGkgaW4gYHNlcSAxMGA7IGRvCglscwoJc2xlZXAgMQpkb25lCmtpbGwgLTEgJHAxIApraWxsIC0x
ICRwMgpraWxsIC0xICRwMwpraWxsIC0xICRwNApraWxsIC0xICRwNQoKZWNobyAiV2FpdCBmb3Ig
cHJvY2Vzc2VzIHRvIGZpbmlzaCIKd2FpdCAkcDEgJHAyICRwMyAkcDQgJHA1CmVjaG8gImFsbCBw
cm9jZXNzZXMgZmluaXNoZWQsIHdhaXQgZm9yIGNsZWFudXAiCnNsZWVwIDIKCm1rZGlyIHggeSB6
CmxzIHggeSB6CnJtZGlyIHggeSB6CmZvciBkIGluIHggeSB6OyBkbwoJaWYgWyAtZCAkZCBdOyB0
aGVuCgkJZWNobyAkZCBzdGlsbCBleGlzdHMKCQlleGl0IC0xCglmaQpkb25lCmVjaG8gU1VDQ0VT
UwpleGl0IDAK

--MP_/yGIqms9mbjClKnAh63rNZ2d
Content-Type: application/octet-stream; name=ftrace-test-mkinstances-2
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=ftrace-test-mkinstances-2

IyEvYmluL2Jhc2gKCmlmIFsgISAtZCAvZGVidWcvdHJhY2luZy9pbnN0YW5jZXMgXTsgdGhlbgoJ
ZWNobyAiTm8gaW5zdGFuY2VzIGRpcmVjdG9yeSIKCWV4aXQgMApmaQoKY2QgL2RlYnVnL3RyYWNp
bmcvaW5zdGFuY2VzCgppbnN0YW5jZV9zbGFtKCkgewoJd2hpbGUgOjsgZG8KCQlta2RpciBmb28g
Jj4gL2Rldi9udWxsCgkJcm1kaXIgZm9vICY+IC9kZXYvbnVsbAoJZG9uZQp9CgppbnN0YW5jZV9y
ZWFkKCkgewoJd2hpbGUgOjsgZG8KCQljYXQgZm9vL3RyYWNlICY+IC9kZXYvbnVsbAoJZG9uZQp9
CgppbnN0YW5jZV9zZXQoKSB7Cgl3aGlsZSA6OyBkbwoJCWVjaG8gMSA+IGZvby9ldmVudHMvc2No
ZWQvc2NoZWRfc3dpdGNoCglkb25lIDI+IC9kZXYvbnVsbAp9CgppbnN0YW5jZV9zbGFtICYKeD1g
am9icyAtbGAKcDE9YGVjaG8gJHggfCBjdXQgLWQnICcgLWYyYAplY2hvICRwMQoKaW5zdGFuY2Vf
c2V0ICYKeD1gam9icyAtbCB8IHRhaWwgLTFgCnAyPWBlY2hvICR4IHwgY3V0IC1kJyAnIC1mMmAK
ZWNobyAkcDIKCnNsZWVwIDEwCgpraWxsIC0xICRwMSAKa2lsbCAtMSAkcDIKCmVjaG8gIldhaXQg
Zm9yIHByb2Nlc3NlcyB0byBmaW5pc2giCndhaXQgJHAxICRwMgplY2hvICJhbGwgcHJvY2Vzc2Vz
IGZpbmlzaGVkLCB3YWl0IGZvciBjbGVhbnVwIgpzbGVlcCAyCgpta2RpciBmb28KbHMgZm9vCnJt
ZGlyIGZvbwppZiBbIC1kIGZvbyBdOyB0aGVuCgllY2hvIGZvbyBzdGlsbCBleGlzdHMKCWV4aXQg
LTEKZmkKZWNobyBTVUNDRVNTCmV4aXQgMAo=

--MP_/yGIqms9mbjClKnAh63rNZ2d--
