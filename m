Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3HLHUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:20:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18947 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3HLHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:20:33 -0400
X-AuditID: cbfee691-b7fef6d000002d62-52-52088cbec24c
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Chris Ball'" <cjb@laptop.org>, "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-4-git-send-email-dianders@chromium.org>
 <001a01ce9505$59c28b20$0d47a160$%jun@samsung.com>
 <CAD=FV=VO=50uMXfwY5iNa+xiamRiHTSpTMXs+EdMeUTawkeyqw@mail.gmail.com>
In-reply-to: <CAD=FV=VO=50uMXfwY5iNa+xiamRiHTSpTMXs+EdMeUTawkeyqw@mail.gmail.com>
Subject: RE: [PATCH v4 3/4] mmc: dw_mmc: Always setup the bus after
 suspend/resume
Date: Mon, 12 Aug 2013 16:20:30 +0900
Message-id: <000d01ce972c$6cf14730$46d3d590$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6VFyp9tN9l4MnmQfK6jCLZ2ZszGgB33Wuw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zY919PRxBBjN+WVs8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4MhY+/chW
	8Fei4tD/9+wNjG+Euxg5OSQETCTmXfzPDGGLSVy4t56ti5GLQ0hgGaPE8UePGGGKLp7exgyR
	WMQosenCClYI5w+jxJ2tb8Gq2AS0JP6+eQM2SkRAW+Llg5VgHcwCzcwS8/a0sIAkhAR2MEn8
	mV4EYnMKBEucv7sFrFlYIERiy7LTYDUsAqoSr0+/ZAOxeQVsJSa9OMsOYQtK/Jh8D6iGA2io
	nsT9i1ogYWYBeYnNa94yg4QlBNQlHv3VhTjBSGLJo6uMECUiEvtevGMEOUdCYC6HxI1Zb6FW
	CUh8m3yIBaJXVmLTAWhISEocXHGDZQKjxCwki2chLJ6FZPEsJBsWMLKsYhRNLUguKE5KLzLV
	K07MLS7NS9dLzs/dxAiJ/Ik7GO8fsD7EmAy0fSKzlGhyPjBx5JXEGxqbGVmYmpgaG5lbmpEm
	rCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcenZ9cdnuOy/ry8gFJBqslbHfP78
	aznWr+IVEqS7p3i8czi6ec4sPsVjwptWWiw8NvWLZ/uh7N9MLM+/3IhVTC+69P98i9SzVHmL
	NasnRJ+4kHmi03J6av70xlVlNtxHnrz8Ja3nccU1IGfNsq1L65Qfpv47JDMrV3HDRu8zZtMF
	HDM2f3WwElBiKc5INNRiLipOBAAzF02LEgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jAd19PRxBBktOmFk8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurxeVdc9gsjvzvZ7Q4df0zm8WqXX8YHbg9Zjdc
	ZPHYOesuu0fPzjOMHoeurGX0uHKiidWjb8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5UUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMWYsfPqRreCvRMWh/+/ZGxjfCHcxcnJICJhIXDy9jRnCFpO4cG89
	WxcjF4eQwCJGiU0XVrBCOH8YJe5sfcsIUsUmoCXx980bsA4RAW2Jlw9WMoMUMQs0M0vM29PC
	ApIQEtjBJPFnehGIzSkQLHH+7hawZmGBEIkty06D1bAIqEq8Pv2SDcTmFbCVmPTiLDuELSjx
	Y/I9oBoOoKF6EvcvaoGEmQXkJTavecsMEpYQUJd49FcX4gQjiSWPrjJClIhI7HvxjnECo9As
	JINmIQyahWTQLCQdCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Vn0jsYVzVYHGIU
	4GBU4uH1+MIeJMSaWFZcmXuIUYKDWUmEl7eRI0iINyWxsiq1KD++qDQntfgQYzLQmxOZpUST
	84EpL68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGPnKlcPM
	ZWyfbMmYsj2t5sBksewMpzrVKZ3zpih525fLvToRWdO2TnfdA1m7p6yWH5e8/T/h8pnAF5v3
	vq3f7F7g432+5+QCubLao/FOqg+ePn/422WlGZeQUPjkr4fj2n4XbrxbFxER1dU+f9/UPNOA
	aT/Nn4dWhO70LGZbFyl1vLXr3L/wN0osxRmJhlrMRcWJAFDeCBtvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, August 10, 2013,Doug Anderson wrote:
> Seungwon,
> 
> On Fri, Aug 9, 2013 at 6:35 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > On Wed, August 07, 2013, Doug Anderson wrote:
> >> After suspend/resume all of the dw_mmc registers are reset to
> >> defaults.  We restore most of them, but specifically don't setup the
> >> clock registers after resume unless we've got a powered card.  Things
> >> still work because the core will eventually call set_ios() and we'll
> >> set things up.
> >
> > Hmm, I didn't get the need of this call during resume.
> > I think set_ios is only valid where core layer calls.
> > Besides, important things is ios's parameters.
> > If suspend has finished successfully, last call of set_ios() is from mmc_power_off().
> > On seeing fields of 'mmc->ios' stored last, these values aren't proper in resume phase.
> > Please check mmc_power_off() function.
> > In case MMC_PM_KEEP_POWER it could be kept.
> 
> Most of my reasoning has to do with the fact that the state of the
> system after suspend/resume should not be significantly different than
> the state of the system before suspend/resume.  If the state of the
> system is different in the two cases it points out potential problems
> or inefficiencies.
> 
> To make this more concrete:
> 
> 1. Boot up a system with no card in the SD Card slot.
> 2. Note down the value of registers like CLKDIV, CLKENA, etc.
> 3. Suspend / resume (S2R)
> 4. Check the values of CLKDIV, CLKENA, etc.
> 
> You will notice that they are different.  This is a bad sign and can
> be a source of bugs (though I don't know of any).  ...or it could mean
> that power draw is different (could be better, could be worse) after a
> suspend/resume cycle.
> 
> 
> Said another way, if the value of CLKDIV, CLKENA, etc is not important
> when a card is not inserted, why do they get initialized at boot time?
> 
> 
> In general, I think that the mmc core code makes the assumption that
> it's up to the driver to make sure that its state is preserved across
> S2R.  For dw_mmc the driver doesn't do the "brute force" that some
> drivers do of just saving and restoring all registers using a copy
> loop.  Instead, the dw_mmc driver runs code that tries to set the
> state back to something reasonable.  Without my patch the dw_mmc
> driver doesn't run any code that restores these registers.
> dw_mci_set_ios() will do so.

This seems pretty associated with [1/4 patch]. (Anyway continued, ...)
Basically, both CLKDIV and CLKENA will be set with the reset value of zero. This means clock is disabled.
While resume of dw_mmc is completed, initial configuration registers will be set except for runtime registers.
I think registers related to clock are close to runtime.
Core layer knows the correct clock rate for current device mode and will actually request it by set_ios.
If core layer requests set_ios no more after dw_mmc resume is completed, dw_mmc will keep the clock to be disabled.
Then, dw_mmc doesn't need self call of dw_mci_set_ios.

Thanks,
Seungwon Jeon
> 
> Another option would be to forcibly save/restore registers in suspend/resume.
> 
> -Doug

