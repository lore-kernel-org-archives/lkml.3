Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbaGQN51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:57:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29457 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaGQN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:57:23 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a8-53c7d6404442
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Sachin Kamat <spk.linux@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, cpgs@samsung.com,
        Grant Grundler <grundler@chromium.org>, jic23@kernel.org
Subject: Re: [PATCH 1/4 v2] iio: exyno-adc: use syscon for PMU register access
Date: Thu, 17 Jul 2014 15:56:55 +0200
Message-id: <4202302.OdUuvHROuH@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAHfPSqDBfdmt2R4yB1AUG9U8UvsYtmVtL03-OMuozKGXYGdMgw@mail.gmail.com>
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
 <CAK5sBcFR0nwmL97CYxhHHhwHREdNOMYZnc2DF+O=WdQLBHQbLA@mail.gmail.com>
 <CAHfPSqDBfdmt2R4yB1AUG9U8UvsYtmVtL03-OMuozKGXYGdMgw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xgK7DtePBBtsmW1vcfX6Y0eLlIU2L
	61+es1rMP3KO1aJ58Xo2i1dHfjBZPGhaxWSxZPJ8Vot5R96xWFzeNYfNYsb5fUwWi7b9Z7Zo
	+XqOxYHXY3bDRRaPnbPusntsWtXJ5rF/7hp2jyVvDrF69G1ZxejxeZNcAHsUl01Kak5mWWqR
	vl0CV8aaGY1sBWs4K7ZePcTawLiVvYuRk0NCwETibutHZghbTOLCvfVsXYxcHEICixglOmYd
	YoRwWpgkbvx/wQRSxSZgJTGxfRUjiC0iYCQx88FCsCJmgTfMEuuWPmIDSQgL+Em0LvrPAmKz
	CKhKTNk/FSzOK6ApsfXnHLC4qICnxI7tK8HinALBEnv+9TBBbLvMKNF19DELRIOgxI/J98Bs
	ZgF5iX37p7JC2OoSk+YtYp7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iREcOc+kdjCubLA4xCjAwajEw5vQeixYiDWxrLgy9xCjBAezkgjvtq7jwUK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYuW5zzhFaeGq2UopIxRn/
	mZNFcuZ9svHzDw7alaXGqePnlLfqb0fBxISApJzs//WpcT0RTW1d87Of3437yWgwtfRozyWu
	j9MvVrXdFS5Y0fdZJt7qf/KmpqozisfqQkRuXc9IVIuwyulwXTDlwdNHs3wmliyZUagpt/gN
	Q6qPb92UkDUXeGcpsRRnJBpqMRcVJwIAfE6rk5gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, July 17, 2014 05:41:16 PM Naveen Krishna Ch wrote:
> Hello Sachin,
> 
> On 17 July 2014 17:24, Sachin Kamat <spk.linux@gmail.com> wrote:
> > Hi Naveen,
> >
> > On Thu, Jul 17, 2014 at 4:49 PM, Naveen Krishna Chatradhi
> > <ch.naveen@samsung.com> wrote:
> >> This patch updates the IIO based ADC driver to use syscon and regmap
> >> APIs to access and use PMU registers instead of remapping the PMU
> >> registers in the driver.
> >>
> >> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> >> To: linux-iio@vger.kernel.org
> >
> > With only this patch applied, I believe the ADC functionality would be broken.
> > Perhaps the DT changes should be merged along with this patch?
> 
> Jonathan already mentioned that, he would wait for Ack from Kukjin.
> With out the dts changes ADC driver will fail to probe but it wont
> crash the system.
> git bisect should still work.

Unless someone bisects things related to ADC functionality..

Also patch #1 seems to break device tree ABI (the old dtb will no longer
work with the new kernel).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

