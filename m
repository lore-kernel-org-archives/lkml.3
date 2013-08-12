Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3HLHOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:14:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12428 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3HLHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:14:42 -0400
X-AuditID: cbfee68f-b7f436d000000f81-6a-52088b5f4ee7
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'Olof Johansson'" <olof@lixom.net>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-2-git-send-email-dianders@chromium.org>
 <001801ce9504$d9976ab0$8cc64010$%jun@samsung.com>
 <CAD=FV=VmtoxnRzjsKF1rVTwvkJRAxKGUvNZHAEwuWaeVokzSZA@mail.gmail.com>
In-reply-to: <CAD=FV=VmtoxnRzjsKF1rVTwvkJRAxKGUvNZHAEwuWaeVokzSZA@mail.gmail.com>
Subject: RE: [PATCH v4 1/4] mmc: dw_mmc: Invalidate cache of current_speed
 after suspend/resume
Date: Mon, 12 Aug 2013 16:14:38 +0900
Message-id: <000c01ce972b$9ba23590$d2e6a0b0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6VFE1azDzWQV/1SI2T+C6ql5TPVACCjFJg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zA934bo4gg4+fFSwer1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzWLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGXPW97EU
	fFSsWPCrnaWB8atkFyMnh4SAicSFY7vZIGwxiQv31gPZXBxCAssYJf4cXcAIUzTz+QeoxHRG
	iYMdZxghnD+MEssOLAGrYhPQkvj75g1zFyMHh4hAuMTemyogYWaB60wSR3ekQdTvYJLofPIa
	rJ5TIFhi7a77TCC2sECixMkll8HiLAKqEle3LmIHsXkFbCUmLT7DDGELSvyYfI8FZD6zgJ7E
	/YtaEPPlJTaveQu2VkJAXeLRX12QsIiAkUTHs7ksECUiEvtevAM7WUJgLofErP+NLBCrBCS+
	TT7EAtErK7HpADPEv5ISB1fcYJnAKDELyeJZCItnIVk8C8mGBYwsqxhFUwuSC4qT0ouM9YoT
	c4tL89L1kvNzNzFC4r5/B+PdA9aHGJOBtk9klhJNzgemjbySeENjMyMLUxNTYyNzSzPShJXE
	edVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MB44tLBq4yKeza01D/wz7tbqFDh43XtV
	zXB18aTMN58uyHBqJ2hFFjSypmr9vhA6dcKtsikGG6M9xRWNV77nVFYv5TUSvy4m4bXvCv+x
	Xwk68f9PRvts1dvqNSvSfprkuZfb5dSad6+9XZYp9tw3g5FNjJ/b2E3LIySxn09EKHjm3wdx
	qldklViKMxINtZiLihMB7tjJ+xEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd34bo4ggwcrpC0er1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzWLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFcqKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwnrGDPmrO9jKfioWLHgVztLA+NXyS5GTg4JAROJmc8/sEHYYhIX7q0H
	srk4hASmM0oc7DjDCOH8YZRYdmAJI0gVm4CWxN83b5i7GDk4RATCJfbeVAEJMwtcZ5I4uiMN
	on4Hk0Tnk9dg9ZwCwRJrd91nArGFBRIlTi65DBZnEVCVuLp1ETuIzStgKzFp8RlmCFtQ4sfk
	eywg85kF9CTuX9SCmC8vsXnNW7C1EgLqEo/+6oKERQSMJDqezWWBKBGR2PfiHeMERqFZSAbN
	Qhg0C8mgWUg6FjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITirPpHYwrmywOMQowMGo
	xMPr8YU9SIg1say4MvcQowQHs5IIL28jR5AQb0piZVVqUX58UWlOavEhxmSgNycyS4km5wMT
	Xl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MCZP66g6Jn1+
	4QFpkZlnbojdnWhk2td7b6rzj8beBgvLpbt8jC/dyvG1u+otIa53Rckh+vSvyYsqPphNcNgj
	uVSX8/fjsKDGtCWSy6o2LDCY/XF92MpL/ed+z2UXfVP2/D1PROPi/cxb3wgtWWnw7dXhwjDv
	yLP3dUtTKtaYGq0xXDOlcj1T7xklluKMREMt5qLiRAAJGVdIbgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, August 10, 2013, Doug Anderson wrote:
> Seungwon and Jaehoon,
> 
> On Fri, Aug 9, 2013 at 6:32 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > On Wed, August 07, 2013, Doug Anderson wrote:
> >> The dw_mmc driver keeps a cache of the current slot->clock in order to
> >> avoid doing a whole lot of work every time set_ios() is called.
> >> However, after suspend/resume the register values are bogus so we need
> >> to ensure that the cached value is invalidated.
> > This mismatch comes only in case MMC_PM_KEEP_POWER, right?
> 
> Actually, no.  I saw problems with the SD Card slot, which doesn't
> have MMC_KEEP_POWER.  Problems showed up when no card was inserted
> across suspend/resume.  In other words:
> 
> 1. At boot time, slot is all setup and configured to 400kHz.
> 
> 2. Suspend
> 
> 3. Resume; clock registers are reset (by suspend/resume) and not
> restored since dw_mmc still thinks slot is configured for 400kHz due
> to host->current_speed cache.
> 
> 4. Insert card.
> 
> 5. No code sees any need to change the clock for detecting the card,
> since everyone thinks it's at 400kHz.  ...but it's not.

Doug, your analysis is right.
But, let me suggest another approach.
After step #1, core layer actually call mmc_power_off because slot is empthy(get_cd() is '0').
Then, set_ios is requested with 'ios->clock'.
However, because current implementation doesn't update current_speed in case ios->clock is '0'.
It causes current_speed has invalid clock rate in resume of dw-mmc.

So, if we can update slot->clock properly, it will be fixed.

-static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
+static void dw_mci_setup_bus(struct dw_mci_slot *slot)
 {
        struct dw_mci *host = slot->host;
        u32 div;
        u32 clk_en_a;

-       if (slot->clock != host->current_speed || force_clkinit) {
+       if (slot->clock && (slot->clock != host->current_speed)) {


@@ -807,13 +807,11 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)

        mci_writel(slot->host, UHS_REG, regs);

-       if (ios->clock) {
-               /*
-                * Use mirror of ios->clock to prevent race with mmc
-                * core ios update when finding the minimum.
-                */
-               slot->clock = ios->clock;
-       }
+       /*
+        * Use mirror of ios->clock to prevent race with mmc
+        * core ios update when finding the minimum.
+        */
+       slot->clock = ios->clock;

Thanks,
Seungwon Jeon

> 
> 
> >> In many cases we got by without this since the core mmc code fiddles
> >> with the clock a lot.  If we've got a card present we're probably
> >> running it at something like 50MHz and the core will temporarily
> >> switch us to 400kHz after resume.  One case that didn't work (for me)
> >> is the case of having no card in the slot.  The slot is initted to
> >> 400kHz at boot time.  After suspend/resume the slot thinks it's still
> >> at 400kHz (due to the cache) so doesn't adjust timing.  When it tries
> >> to send the command at probe time it just times out and gets left in a
> >> bad state.
> > I understand this change although some part of commit message (boot time, probe time...) make me
> confused.
> 
> Sorry to be confusing.  I was trying to explain why the old code works
> fine in many cases.  It's because the core MMC code tends to adjust
> the clock a lot around suspend/resume.  When it does that, it works
> around this problem.  ...but I found one case where suspend/resume
> would happen and the MMC core didn't adjust the clock.
> 
> 
> > I guess this change intends to update clock programming forcedly.
> > It looks like another version of 'dw_mci_setup_bus(slot, true)'.
> > Eventually, this change does same?
> 
> Effectively, yes.  As Jaehoon points out, that means we can actually
> eliminate the "force" parameter to dw_mci_setup_bus().
> 
> 
> I will send a new version out that eliminates the "force" parameter
> and updates the commit message to (hopefully) be clearer.
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

