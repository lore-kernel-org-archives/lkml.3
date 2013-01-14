Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3ANQnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:43:35 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46015 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab3ANQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1301132125530.25830-100000@netrider.rowland.org>
References: <1406914.PAZOOLqX4X@linux-5eaq.site> <Pine.LNX.4.44L0.1301132125530.25830-100000@netrider.rowland.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Mon, 14 Jan 2013 17:43:12 +0100
Message-ID: <CALxABCZbrFLbnm7ZW3iTSmcfwMsSQx+fY7srEZpU1-=Ostcc0g@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Jens Axboe <axboe@kernel.dk>,
        linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b33d8c480810604d34258e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b33d8c480810604d34258e2
Content-Type: text/plain; charset=UTF-8

On Mon, Jan 14, 2013 at 3:39 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 13 Jan 2013, Oliver Neukum wrote:
>> This is not a USB problem. You need to involve the SCSI people.
>> khubd just stops working because disconnects are processed
>> in its context and the removal deadlocks.
>
> The why whould building the deadline elevator as a module make any
> difference?  Or does it make a difference?

Building elevator as module does make a difference: the system is broken.

> Alex, if the elevator is made static instead, do you still see the same
> behavior when the USB drive is removed?

How can I make the elevator static? Or did you mean "built-in"?
Or did you mean to ask if khubd hangs if the deadline is built in?
In that case - no. The behavior is normal. Nothing hangs.

> Also, are there any mounted filesystems on the drive when you unplug
> it?

No, no auto-mount. The whole of userspace init is attached, and I'm reasonably
sure nothing of it mounts anything automatically. Nothing of udev, too.

--047d7b33d8c480810604d34258e2
Content-Type: application/octet-stream; name=linuxrc-t
Content-Disposition: attachment; filename=linuxrc-t
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbxu0q2i0

IyEvYmluL2Jhc2ggLXYKIyBTRVRVUAptb3VudCAtbnQgcHJvYyAgcHJvYyAvcHJvYwptb3VudCAt
bnQgc3lzZnMgc3lzZnMgL3N5cwood2hpbGUgcmVhZCBkIG0gcjsgZG8gWyAiJGQiID0gZGV2dG1w
ZnMgLWEgIiRtIiA9IC9kZXYgXSAmJiBleGl0IDAKIGRvbmUgPCAvcHJvYy9tb3VudHMpIHx8IHsK
CW1vdW50IC10IHRtcGZzIGRldmZzIC90bXAgJiYKCWNwIC1hIC9kZXYvKiAvdG1wICYmCgltb3Vu
dCAtLW1vdmUgL3RtcCAvZGV2Cn0KdGVzdCAtZCAvZGV2L3B0cyB8fCBta2RpciAvZGV2L3B0cwpt
b3VudCAtbnQgZGV2cHRzIGRldnB0cyAvZGV2L3B0cyAmCigKCWlmY29uZmlnIGxvIHVwCgl0ZXN0
IC1mIC9ldGMvaG9zdG5hbWUgJiYgaG9zdG5hbWUgLS1maWxlIC9ldGMvaG9zdG5hbWUKKSYKCigK
CWNnPTsgd2hpbGUgcmVhZCBnIHI7IGRvCgkJWyAiJHtnOjA6MX0iID0gJyMnIF0gfHwgY2c9IiRj
ZywkZyIKCWRvbmUgPCAvcHJvYy9jZ3JvdXBzCglta2RpciAvZGV2L2Nncm91cHMgJiYKCW1vdW50
IC1udCBjZ3JvdXAgLW8gIiR7Y2c6MX0iIGNncm91cCAvZGV2L2Nncm91cHMKKSYKCigKCW1vdW50
IC1udCB0bXBmcyBydW4gL3J1biAmJgoJbWtkaXIgL3J1bi9sb2NrIC9ydW4vbmV0d29yawopICYK
bW91bnQgLW50IHRtcGZzIHRtcCAvdG1wICYKKAoJbWtkaXIgL2Rldi9zaG0gJiYKCW1vdW50IC1u
dCB0bXBmcyBzaG0gL2Rldi9zaG0gLW8gbm9kZXYsbm9zdWlkLHJlbGF0aW1lCikmCm1vdW50IC1u
dCBkZWJ1Z2ZzIGRlYnVnZnMgL3N5cy9rZXJuZWwvZGVidWcgJgoKd2FpdApyZWFkIHQgPCAvcHJv
Yy91cHRpbWUgJiYgZWNobyAkdAoKSE9NRT0vdG1wICMgZG8gbm90IGV4cG9ydCBIT01FIGZvciB1
ZGV2CkhPTUU9JEhPTUUgb3BlbnZ0IC1jIDIgLXcgLS0gL2Jpbi9iYXNoICYKL3NiaW4vdWRldmQg
LS1kYWVtb24KL3NiaW4vdWRldmFkbSB0cmlnZ2VyCi9zYmluL3VkZXZhZG0gc2V0dGxlCnNldCAr
diAjIEVORCBPRiBNQUlOIFNFVFVQCnJlYWQgdCA8IC9wcm9jL3VwdGltZSAmJiBlY2hvIC1lICJc
ZVsxbVVwdGltZSB0aWxsIG5vdzogJHRcZVswbSIKCmV4cG9ydCBIT01FCgp0ZXN0IC1lIC9wcm9j
L3N3YXBzICYmIHsKCWVjaG8gQWN0aXZhdGluZyBzd2FwLi4uCglzd2Fwb24gLWEgJgp9Cgp0ZXN0
IC14IC9zYmluL3JlYWRhaGVhZC1saXN0ICYmIHsKCWVjaG8gUHJlbG9hZGluZyBwcm9ncmFtcy4u
LgoJKAoJZm9yIGYgaW4gL3Vzci9iaW4vdmltIC91c3IvYmluL3RvcCA7IGRvCgkJbGRkIC12ICIk
ZiIgfGdyZXAgIl5bCV0vLio6JCJ8Y3V0IC1jMi18Y3V0IC1kOiAtZjEKCWRvbmUgMj4vZGV2L251
bGwgfCBncmVwIC12ICJeL2xpYi8iID4gL3RtcC9yZWFkYWhlYWQKCXRlc3QgLWUgL3RtcC9yZWFk
YWhlYWQgJiYgewoJCS9zYmluL3JlYWRhaGVhZC1saXN0IC90bXAvcmVhZGFoZWFkCgkJcm0gLWYg
L3RtcC9yZWFkYWhlYWQKCX0KCSkgJgp9CgplY2hvIDkgPi9wcm9jL3N5c3JxLXRyaWdnZXIKZWNo
byAtZSAnXGVbMzI7MW0nJCh1bmFtZSAtYSknXGVbMG0nCgpleHBvcnQgSE9NRQooc2hvcHQgLXMg
bnVsbGdsb2IKZ3JlcCAtcSBub3Rlc3RzIC9wcm9jL2NtZGxpbmUgfHwKZm9yIExJTlVYUkNfVEVT
VCBpbiAvYm9vdC90ZXN0cy8qOyBkbwoJaWYgdGVzdCAteCAiJExJTlVYUkNfVEVTVCIKCXRoZW4K
CQlleHBvcnQgTElOVVhSQ19URVNUCgkJZWNobyBURVNUSU5HICIkTElOVVhSQ19URVNUIgoJCSgu
ICIkTElOVVhSQ19URVNUIikKCWZpCmRvbmUpICYKCiMgcmVib290IHRocm91Z2ggdGhyZWUgcHJl
c3NlcyBvZiBwb3dlciBidG4KKGZvciBlIGluIC9zeXMvY2xhc3MvaW5wdXQvZXZlbnQqL2Rldmlj
ZS9uYW1lCmRvCglpZiBbICIkKDwgJGUpIiA9ICdQb3dlciBCdXR0b24nIF07IHRoZW4KCQlkZXY9
JHtlJS9kZXZpY2UvbmFtZX0KCQlleGVjIC91c3IvbG9jYWwvYmluL2lucHV0LWV2ZW50IC1kIC9k
ZXYke2RldjoxMH0gXAoJCQktYiBwb3dlciAtdDUgLXIzIC0tIC9zYmluL3JlYm9vdCAtZgoJZmkK
ZG9uZSkgJgoKIyB1c2VyIHNoZWxsCndoaWxlIDo7IGRvIC9zYmluL2dldHR5IDM4NDAwIHR0eTM7
IGRvbmUgJgp3aGlsZSA6OyBkbyAvc2Jpbi9nZXR0eSAzODQwMCB0dHk0OyBkb25lICYKIyBYIGVu
dmlyb25tZW50CmdyZXAgLXEgbm9zdGFydHggL3Byb2MvY21kbGluZSB8fAooIG1vdW50IC1yIC92
YXIKICB0ZXN0IC1kIC92YXIvbGliL3N1ZG8gJiYgbW91bnQgLXQgdG1wZnMgLW8gc2l6ZT0kKCgx
KjEwMjQqMTAyNCkpIHN1ZG8gL3Zhci9saWIvc3VkbwogIHRlc3QgLXggL3Zhci9teS1zdGFydHgg
JiYKICBtb3VudCAtciAvaG9tZSAmJgogIG1vdW50IC10IHRtcGZzIC1vIHNpemU9JCgoMSoxMDI0
KjEwMjQpKSB4a2IgL3Zhci9saWIveGtiICYmCiAgbW91bnQgLXQgdG1wZnMgLW8gc2l6ZT0kKCgx
NSoxMDI0KjEwMjQpKSB2YXJsb2cgL3Zhci9sb2cgJiYKICAvdmFyL215LXN0YXJ0eCApJgoKTklD
RT0KdHlwZSAtcCBuaWNlID4vZGV2L251bGwgJiYgTklDRT0ibmljZSAtbiAtMyIKZXhlYyAkTklD
RSAvYmluL2Jhc2gK
--047d7b33d8c480810604d34258e2--
