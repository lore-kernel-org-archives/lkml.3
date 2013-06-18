Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab3FRMgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:36:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3FRMgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:36:15 -0400
X-AuditID: cbfee691-b7fef6d000002d62-9a-51c0543e4692
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
 <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
 <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
 <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
 <CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
In-reply-to: <CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
Subject: RE: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Date: Tue, 18 Jun 2013 21:36:13 +0900
Message-id: <001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5nn/4Mso4caoRfTTCn8q9BQfbxFgDpDP3A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zfV27kAOBBlceS1hsXhdvMW/rUVaL
	7a83slmcXXaQzeLGrzZWi8u75rBZHPnfz2hx6vpnNosNd6eyWizcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxpvvO9gLfnBWtF44
	ydzAeIO9i5GTQ0LAROLPpGVsELaYxIV764FsLg4hgWWMEhv3TWWCKfp7to8FIrGIUeL8tKNM
	EM4fRon5E98zg1SxCWhJ/H3zBswWEdCWePlgJTNIEbPAKSaJyU/nMEJ0HGGW2PZ8GytIFadA
	sMS0uS9YQGxhgWiJA207wI5iEVCVmDV/DlgNr4CtxIy7Z1ggbEGJH5PvgdnMAnoSH//cZoSw
	5SU2r3kLtI0D6FZ1iUd/dSGOMJJ4v+kZVLmIxL4X78BukBCYyCHxbs8JqF0CEt8mH2KB6JWV
	2HSAGeJlSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS
	83M3MUJifuIOxvsHrA8xJgOtn8gsJZqcD0wZeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgzMwKVnnx9PxlpcjH3h5FhY/4Ch/l7dwTraK+4EPE
	wZyoe83NmpmrvvaLerPE3pvJZOHT1nJy+67DU315rYpPqTMeLJgWeiil9M7Mjao/yh/M9T90
	b5pxlkSMKc+1/rDii5qzz+79ue9Tfuuy64I93pY3kiO3Sh47lNxx0f3/xLs33VYZs4a9V2Ip
	zkg01GIuKk4EAEPZRUYPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAV27kAOBBn9vCVtsXhdvMW/rUVaL
	7a83slmcXXaQzeLGrzZWi8u75rBZHPnfz2hx6vpnNosNd6eyWizcdIjNgctjdsNFFo+ds+6y
	exy6spbR48qJJlaPyQsvMnv0bVnF6PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMI6xow333ewF/zgrGi9cJK5gfEGexcjJ4eEgInE37N9LBC2mMSFe+vZuhi5OIQE
	FjFKnJ92lAnC+cMoMX/ie2aQKjYBLYm/b96A2SIC2hIvH6xkBiliFjjFJDH56RxGiI4jzBLb
	nm9jBaniFAiWmDb3BdgOYYFoiQNtO8B2swioSsyaPweshlfAVmLG3TMsELagxI/J98BsZgE9
	iY9/bjNC2PISm9e8BdrGAXSrusSjv7oQRxhJvN/0DKpcRGLfi3eMExiFZiGZNAvJpFlIJs1C
	0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBCeSa9g3FVg8UhRgEORiUe3gSx/YFC
	rIllxZW5hxglOJiVRHhr/Q8ECvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MNnllcQbGpuY
	GVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjhWrzxVzOQsZ5eZmf5k7i
	PGrUIuJSYWP2/s4tXS2e9IPWoiYrH9m0c3mr7Dxj8vzMNeMNG7QUOdbL8Iifdk6+pFnAtvmv
	dnrvrtT8DxZKAj/MvM7+OqnyQ7hPXPi258NdAR0/RSddfl4RtEjn2+szcj7bpHhunFK+fF/w
	TsKcd6meQdGL99gpsRRnJBpqMRcVJwIAhRmVu2wDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 13, 2013, Doug Anderson wrote:
> Seungwon,
> 
> On Wed, Apr 10, 2013 at 12:02 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> > There are two solutions we have applied.
> >>
> >> I'm a little confused.  Have you already applied one or both of the
> >> solutions you list below, or are you proposing them as alternates to
> >> the patch I submitted?
> > Yes, first one already has been applied.
> > I wanted to introduce our fix. Did you try to test with these fixes?
> 
> I'm coming back to this after being quite distracted for a while.
> 
> I'm a little confused in that you said that your first fix was already
> applied.  I don't see it anywhere.  Did you mean that you've already
> applied it locally, or that it's applied in some git tree somewhere?
> If so, can you point me to it?
> 
> If this hasn't been sent out anywhere, perhaps you could send out
> official patches?
Currently, it has just applied for some projects, not official patch.
> 
> I don't have the failing unit myself, so we'll have to get Bing to try
> the patches.  You are suggesting that we try applying both of your
> patches, right?
Did you test the patch?
I wonder that both are good for your side.

Thanks,
Seungwon Jeon
> 
> -Doug

