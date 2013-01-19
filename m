Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3ASXGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 18:06:19 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:42872 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3ASXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 18:06:17 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVqR9FCk4PcoXJJwa+zEkU3rf6cDwvYKkocfJpVhGo7xQ@mail.gmail.com>
References: <CA+icZUWKCbaL=oAwBk0vcPtLrGmvsqPdpXdYAqPZVKzA9Y_iDw@mail.gmail.com>
	<50FB2197.7010306@ilyx.ru>
	<CA+icZUU-4WXXMTCjRWP6H7+JhytBSWuA55-JFyu3yowcT6Q4xw@mail.gmail.com>
	<50FB249D.4050906@ilyx.ru>
	<CA+icZUVqR9FCk4PcoXJJwa+zEkU3rf6cDwvYKkocfJpVhGo7xQ@mail.gmail.com>
Date: Sun, 20 Jan 2013 00:06:16 +0100
Message-ID: <CA+icZUUY8tJEC-NgENnZHXzoSOTJ6BFqe2NeqPM_Pdh7Tk2W4w@mail.gmail.com>
Subject: Re: [next-20130118] Analyzing a call-trace reproducible with
 pm_test/freezer [ X86|RCU|TTY|EXT4FS|JBD2|PM related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        linux-serial@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Jan Kara <jack@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: multipart/mixed; boundary=20cf3068447d6b134204d3ac46a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3068447d6b134204d3ac46a7
Content-Type: text/plain; charset=UTF-8

On Sat, Jan 19, 2013 at 11:59 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Jan 19, 2013 at 11:56 PM, Ilya Zykov <ilya@ilyx.ru> wrote:
>> On 20.01.2013 2:51, Sedat Dilek wrote:
>>> On Sat, Jan 19, 2013 at 11:43 PM, Ilya Zykov <ilya@ilyx.ru> wrote:
>>>> Hello!
>>>> I don't expert, but
>>>> maybe it can help.
>>>>
>>>> I test with:
>>>>   while echo mem > /sys/power/state; do sleep 2; done
>>>> in one X-terminal, in other I trying playing with keyboard.
>>>> (Without playing all right I use ext3.)
>>>
>>> Can you test with the patches listed in [1] (including two TTY patches
>>> from you!)?
>>> My base is Linux-Next (next-20130118).
>>> FYI: My Ubuntu/precise is EXT4FS-formatted.
>>>
>> Ok.
>> but not now I have 3.00 night.
>> I already use this in my 3.8.0-rc3-next-20130118-pm+.
>>  tty: Correct tty buffer flush.
>>
>
> The TTY patches are not enough, you need in addition the JBD2 fix [1].
>

Attached is a testcase script which helped here to hit the issue!

- Sedat -

> - Sedat -
>
> [1] http://patchwork.ozlabs.org/patch/207237/
>
>>

--20cf3068447d6b134204d3ac46a7
Content-Type: application/x-sh; name="run_pm-test.sh"
Content-Disposition: attachment; filename="run_pm-test.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hc5d8kgf0

IyEvYmluL2Jhc2gKCiMgSEVMUAojIFsxXSBodHRwOi8vZ2l0Lmtlcm5lbC5vcmcvP3A9bGludXgv
a2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQ7YT1ibG9iO2Y9RG9jdW1lbnRhdGlvbi9wb3dl
ci9iYXNpYy1wbS1kZWJ1Z2dpbmcudHh0CiMgWzJdIGh0dHA6Ly9naXQua2VybmVsLm9yZy8/cD1s
aW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdDthPWJsb2I7Zj1Eb2N1bWVudGF0aW9u
L3Bvd2VyL2ZyZWV6aW5nLW9mLXRhc2tzLnR4dAoKZXhwb3J0IExBTkc9QwpleHBvcnQgTENfQUxM
PUMKCiMgRGVmYXVsdCB2YWx1ZSBvZiBodW5nX3Rhc2tfdGltZW91dF9zZWNzIGlzIDEyMCBbc2Vj
c10KU0VDUz0iMCIKCiMgUG9zc2libGUgdHlwZXM6IG5vbmUgY29yZSBwcm9jZXNzb3JzIHBsYXRm
b3JtIGRldmljZXMgZnJlZXplcgpQTV9URVNUX1RZUEU9ImZyZWV6ZXIiCgojIENvdW50ZXIgYW5k
IGxvb3BzCkNPVU5URVI9IjAiCkxPT1BTPSIxMCIKCmVjaG8gIiRTRUNTIiA+IC9wcm9jL3N5cy9r
ZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcwoKZWNobyAiJFBNX1RFU1RfVFlQRSIgPiAvc3lz
L3Bvd2VyL3BtX3Rlc3QKCndoaWxlIFsgJENPVU5URVIgLWx0ICRMT09QUyBdOyBkbwogICAgZWNo
byBbIHBtX3Rlc3QvZnJlZXplcjogUnVuICRDT1VOVEVSIF0KICAgIGVjaG8gbWVtID4gL3N5cy9w
b3dlci9zdGF0ZSAmJiBzbGVlcCAxCiAgICBlY2hvIFsgcG1fdGVzdC9mcmVlemVyOiBPSyAkQ09V
TlRFUiBdCiAgICBsZXQgQ09VTlRFUj1DT1VOVEVSKzEKZG9uZQo=
--20cf3068447d6b134204d3ac46a7--
