Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3KLDWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 22:22:54 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37248 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3KLDWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 22:22:45 -0500
MIME-Version: 1.0
In-Reply-To: <20131111193236.GB16735@n2100.arm.linux.org.uk>
References: <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com>
	<CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com>
	<CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
	<87y54vzszo.fsf@rustcorp.com.au>
	<CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
	<CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com>
	<CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com>
	<CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com>
	<CACVXFVOnVXcVdRCm=OfPjpvvWCiXi8GRV+9ViOGmSZ3tTf6WDg@mail.gmail.com>
	<528110B1.4060402@arm.com>
	<20131111193236.GB16735@n2100.arm.linux.org.uk>
Date: Tue, 12 Nov 2013 11:22:44 +0800
Message-ID: <CACVXFVPQfUtrc4r4cS9J+6q5Z6hGZDgafH=M_6JfrzrAUGJOHw@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonathan Austin <jonathan.austin@arm.com>, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Axel Lin <axel.lin@ingics.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: multipart/mixed; boundary=047d7b344290b6698104eaf25c0b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b344290b6698104eaf25c0b
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Nov 12, 2013 at 3:32 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Nov 11, 2013 at 05:15:29PM +0000, Jonathan Austin wrote:
>> I've tested the patch below and it solves the ARM side of things - so
>> gives you an option other than a complete revert. Happy to put this in to
>> RMK's patch system if you'd prefer not to have to revert and he's happy
>> with the patch.
>
> I think this is the right solution because it then means that this symbol
> has the same meaning whether on MMU or !MMU - and getting rid of these
> kinds of gratuitous variances are the only way that !MMU is going to
> become less fragile.

The patch only fixes problem on arm, and other !MMU&&!ARM archs
should be affected too.

Also there is no CONFIG_PAGE_OFFSET defined for some ARCHs,
such as 64bit ARCHs.

Currently, I suggest to filter only on ARM as attachment patch if we plan
to merge Jonathan's patch, otherwise a more complicated approach has
to be figured out  to do the filter(such as, define a readonly symbol in
kernel to store PAGE_OFFSET, and let scripts/kallsyms use it for
filtering).



Thanks,
-- 
Ming Lei

--047d7b344290b6698104eaf25c0b
Content-Type: text/x-patch; charset=US-ASCII; name="filter-only-on-arm.patch"
Content-Disposition: attachment; filename="filter-only-on-arm.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnwkowpo0

ZGlmZiAtLWdpdCBhL3NjcmlwdHMvbGluay12bWxpbnV4LnNoIGIvc2NyaXB0cy9saW5rLXZtbGlu
dXguc2gKaW5kZXggMzJiMTBmNS4uMmRjYTk0YSAxMDA2NDQKLS0tIGEvc2NyaXB0cy9saW5rLXZt
bGludXguc2gKKysrIGIvc2NyaXB0cy9saW5rLXZtbGludXguc2gKQEAgLTgyLDcgKzgyLDkgQEAg
a2FsbHN5bXMoKQogCQlrYWxsc3ltb3B0PSIke2thbGxzeW1vcHR9IC0tYWxsLXN5bWJvbHMiCiAJ
ZmkKIAotCWthbGxzeW1vcHQ9IiR7a2FsbHN5bW9wdH0gLS1wYWdlLW9mZnNldD0kQ09ORklHX1BB
R0VfT0ZGU0VUIgorCWlmIFsgLW4gIiR7Q09ORklHX0FSTX0iIF0KKwkJa2FsbHN5bW9wdD0iJHtr
YWxsc3ltb3B0fSAtLXBhZ2Utb2Zmc2V0PSRDT05GSUdfUEFHRV9PRkZTRVQiCisJZmkKIAogCWxv
Y2FsIGFmbGFncz0iJHtLQlVJTERfQUZMQUdTfSAke0tCVUlMRF9BRkxBR1NfS0VSTkVMfSAgICAg
ICAgICAgICAgIFwKIAkJICAgICAgJHtOT1NURElOQ19GTEFHU30gJHtMSU5VWElOQ0xVREV9ICR7
S0JVSUxEX0NQUEZMQUdTfSIK
--047d7b344290b6698104eaf25c0b--
