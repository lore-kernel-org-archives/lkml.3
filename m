Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaCTKDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:03:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21618 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCTKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:03:35 -0400
X-AuditID: cbfee68e-b7f566d000002344-ea-532abcf541c2
Date: Thu, 20 Mar 2014 19:03:33 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
Message-id: <20140320190333.9c3555b097e97d593faddbdd@samsung.com>
In-reply-to: <532988CA.4000008@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
 <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
 <20140318200915.7dd833ce0fddbbd6ecd8dac9@samsung.com>
 <532862ED.8040809@samsung.com>
 <20140319175927.a3feadcacbffe80eca1d3421@samsung.com>
 <CAK9yfHxxo2eFh38gPZkpYf1ueBWySWqPzgLV_tSSykzHhNzN8g@mail.gmail.com>
 <532988CA.4000008@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zY92ve7SCDbYftrG4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2sltMWXSY1eLwm3ZWi5N/
	ehkt1s94zWIx89YaFgd+jycH5zF5zG64yOLx73A/k8eda3vYPDYvqfeYfGM5o0ffllWMHp83
	yXlcOXqGKYAzissmJTUnsyy1SN8ugSuja9l21oJXAhWTdn5la2Ds4e1i5OSQEDCRODJnBiuE
	LSZx4d56ti5GLg4hgWWMEpd2r2SEKep7NYUFIrGIUeLuz4+MEM5kJombL6eAtbMIqEq8/t0C
	ZrMJaEmsnnscrFtEQEXi8qnpYA3MAo2sEr9nnGEHSQgLBEi8ONnAAmLzCjhKbN70hA3E5hTQ
	lng+ZQ2YLSTQyCzRtjgX4gwLiQtNHewQ9YISPybfA+tlBlq2eVsTK4QtL7F5zVtmiPqFHBL3
	HulAHCcg8W3yIaB6DqC4rMSmA1AlkhIHV9xgmcAoNgvJ1FlIps5CMnUBI/MqRtHUguSC4qT0
	IiO94sTc4tK8dL3k/NxNjJBo79vBePOA9SHGZKCVE5mlRJPzgckiryTe0NjMyMLUxNTYyNzS
	jDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwavxUPvSoeEpbA9eR6R6OvzWX
	vXntU87h5bs04WRa6d0pCZ+azy0J/P3bzqu8+tV/SSWtrUusXBW0z+8Ru2C2ZHfBfF4PK63z
	v91Nk8/Plfevzvuok/N7w6M7n/bcvzMt4cPJLz+dotofreXbLh+7p81A2OV5UG3f08Nvjt3O
	yp5qzOnNk3JttRJLcUaioRZzUXEiAIvPIj4MAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jAd2ve7SCDXZtMrO4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2sltMWXSY1eLwm3ZWi5N/
	ehkt1s94zWIx89YaFgd+jycH5zF5zG64yOLx73A/k8eda3vYPDYvqfeYfGM5o0ffllWMHp83
	yXlcOXqGKYAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
	QNctMwfoAyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRtey7awFrwQq
	Ju38ytbA2MPbxcjJISFgItH3agoLhC0mceHeerYuRi4OIYFFjBJ3f35khHAmM0ncfDmFFaSK
	RUBV4vXvFjCbTUBLYvXc44wgtoiAisTlU9PBGpgFGlklfs84ww6SEBYIkHhxsgFsBa+Ao8Tm
	TU/YQGxOAW2J51PWgNlCAo3MEm2LcyHOsJC40NTBDlEvKPFj8j2wXmagZZu3NbFC2PISm9e8
	ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcTJ5J72Bc1WBx
	iFGAg1GJh3fFHs1gIdbEsuLK3EOMEhzMSiK81u5awUK8KYmVValF+fFFpTmpxYcYk4HBMZFZ
	SjQ5H5jo8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMeHb
	vL+zdF784jt1vu7cvQKJjQwGir1H/SdH+t3tvPXdYVHZiv+h+kEVkU8X1EVpxB6JuJAX8kJW
	NCb85dMtO0tzP77NEfhf6aibfvfN+/ZO1bNCvP8uOKqqLp7m8URxnu2qOylvGuZp+i+3Ld0b
	+aFTomuibszXg/OUyrZs7jy0d7eSMa9EuBJLcUaioRZzUXEiAKJZn05qAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 13:08:42 +0100, Tomasz Figa wrote:
> On 19.03.2014 10:01, Sachin Kamat wrote:
> > On 19 March 2014 14:29, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> On Tue, 18 Mar 2014 16:14:53 +0100, Tomasz Figa wrote:
> >>> On 18.03.2014 12:09, Cho KyongHo wrote:
> >>>> On Fri, 14 Mar 2014 20:52:43 +0530, Sachin Kamat wrote:
> >>>>> Hi KyongHo,
> >>>>>
> >>>>> On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >>>>>> This patch uses managed device helper functions in the probe().
> >>>>>>
> >>>>>> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >>>>>> ---
> >>>>> [snip]
> >>>>>
> >>>>>> +       data->clk = devm_clk_get(dev, "sysmmu");
> >>>>>> +       if (IS_ERR(data->clk)) {
> >>>>>> +               dev_info(dev, "No gate clock found!\n");
> >>>>>> +               data->clk = NULL;
> >>>>>> +       }
> >>>>>
> >>>>> Why aren't you returning from here upon error?
> >>>>
> >>>> It is for the case of a System MMU which does not need clock gating.
> >>>>
> >>>
> >>> Are there really such cases?
> >>>
> >>
> >> Yes.
> >> Especially in the case of initial stage of new SoC development.
> >>
> >> I have experianced some software workaround for H/W restriction
> >> needs prevention of clock gating for some devices.
> >
> > So aren't these basically some exceptions/hacks rather than the usual way
> > of functioning of the device?
> >
> 
> This actually raises a good question, whether we really need to support 
> such early development SoC versions in mainline.
> 
> Another thing is that if you need to assure that a clock is ungated, you 
> must acquire it and prepare_enable explicitly, so I don't think this 
> kind of handling is correct.
> 
On early development step of a new SoC, clock related stuffs and
some device drivers like display controller are usually developed in parallel.

In that case, -ENOENT from clk_get() must not treated as an error.
"[PATCH v11 20/17] iommu/exynos: allow having multiple System MMUs for a master H/W"
patch distinguishes -ENOENT from other error values returned by devm_clk_get().

Regards,

KyongHo


