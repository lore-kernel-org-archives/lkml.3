Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaKVVxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 16:53:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:37920 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750863AbaKVVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 16:53:05 -0500
Date: Sat, 22 Nov 2014 16:53:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [ftrace/x86/extable] WARNING: CPU: 0 PID: 1 at init/main.c:803
 do_one_initcall()
Message-ID: <20141122165302.3df22b18@gandalf.local.home>
In-Reply-To: <20141122195926.GA1707@wfg-t540p.sh.intel.com>
References: <20141122184349.GB29361@wfg-t540p.sh.intel.com>
	<20141122141139.78927371@gandalf.local.home>
	<20141122195926.GA1707@wfg-t540p.sh.intel.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_//7A1ITOljLEOrb1hO6IDeDB"
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_//7A1ITOljLEOrb1hO6IDeDB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 22 Nov 2014 11:59:26 -0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

>
> > Is it possible for your tests to see if a branch was rebased before
> > posting bug reports to LKML? This gave me a scare that my new code had
> > the same brain fart in it.
> 
> Sure and good idea! I'll implement it right now.
> 

It should also make sure that the rebase does not include the offending
commit before not sending out the email. A rebase alone may still have
the bug.

And if you really want to be fancy, you can check to see if the code
itself changed. The attached script takes two git releases (SHA1s,
tags, etc) or one git release and uses HEAD, and finds where the two
are different. Not just by commit id, but also by code. I use this
because I'll modify a branch to add an acked-by and not change the code,
but still want to know the last commit that I tested. It may not have
the same commit id.


-- Steve

--MP_//7A1ITOljLEOrb1hO6IDeDB
Content-Type: application/octet-stream; name=git-find-last-same
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=git-find-last-same

IyEvYmluL2Jhc2gKCmlmIFsgJCMgLWx0IDEgXTsgdGhlbgoJZWNobyAidXNhZ2U6IGdpdC1maW5k
LWxhc3Qtc2FtZSBbYnJhbmNoMV0gYnJhbmNoMiIKCWV4aXQKZmkKCmlmIFsgJCMgLWx0IDIgXTsg
dGhlbgoJYjE9IkhFQUQiCgliMj0kMQplbHNlCgliMT0kMQoJYjI9JDIKZmkKCgpsMT1gZ2l0IHJl
di1saXN0IC0tcmV2ZXJzZSAkYjEuLiRiMmAKYzE9YGVjaG8gIiRsMSIgfCB3YyAtbGAKaWYgWyAk
PyAtZ3QgMCBdOyB0aGVuCgllY2hvIGVycm9yIGluIGdpdAoJZXhpdApmaQoKbDI9YGdpdCByZXYt
bGlzdCAtLXJldmVyc2UgJGIyLi4kYjFgCmMyPWBlY2hvICIkbDIiIHwgd2MgLWxgCmlmIFsgJD8g
LWd0IDAgXTsgdGhlbgoJZWNobyBlcnJvciBpbiBnaXQKCWV4aXQKZmkKCmlmIFsgJGMxIC1lcSAw
IC1hICRjMiAtZXEgMCBdOyB0aGVuCgllY2hvICJCcmFuY2ggJGIxIGFuZCAkYjIgYXJlIGVxdWFs
IgoJZXhpdApmaQoKaWYgWyAkYzEgLWVxIDAgXTsgdGhlbgoJZWNobyAiQnJhbmNoICRiMiBjYW4g
YmUgZmFzdCBmb3J3YXJkIHRvICRiMSBpbiAkYzIgY29tbWl0cyIKCWV4aXQKZmkKCmlmIFsgJGMy
IC1lcSAwIF07IHRoZW4KCWVjaG8gIkJyYW5jaCAkYjEgY2FuIGJlIGZhc3QgZm9yd2FyZCB0byAk
YjIgaW4gJGMxIGNvbW1pdHMiCglleGl0CmZpCgppZiBbICRjMSAtZ3QgJGMyIF07IHRoZW4KCXMx
PSIkbDIiCglzMj0iJGwxIgplbHNlCglzMT0iJGwxIgoJczI9IiRsMiIKZmkKCnQxPWBlY2hvICIk
czIiIHwgc2VkIC1uZSAnMXAnIGAKdDI9YGVjaG8gIiRzMiIgfCBzZWQgLW5lICcyLCRwJyBgCgpm
b3IgdDEgaW4gJHMxOyBkbwoJdDI9YGVjaG8gIiRzMiIgfCBzZWQgLW5lICcxcCcgYAoJczI9YGVj
aG8gIiRzMiIgfCBzZWQgLW5lICcyLCRwJyBgCglpZiAhIGdpdCBkaWZmIC0tcXVpZXQgJHQxICR0
MjsgdGhlbgoJCWJyZWFrCglmaQpkb25lCgplY2hvICJmaXJzdCBkaWZmIGJldHdlZW4gJHQxIGFu
ZCAkdDIiCgp0MT1gZ2l0IHJldi1saXN0IC0tbWF4LWNvdW50PTEgJHQxfjFgCnQyPWBnaXQgcmV2
LWxpc3QgLS1tYXgtY291bnQ9MSAkdDJ+MWAKCmVjaG8gImZpcnN0IHNhbWUgYmV0d2VlbiAkdDEg
YW5kICR0MiIKCg==

--MP_//7A1ITOljLEOrb1hO6IDeDB--
