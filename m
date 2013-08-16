Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3HPLR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:17:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48818 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3HPLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:17:24 -0400
X-AuditID: cbfee68e-b7f276d000002279-54-520e0a429b92
Date: Fri, 16 Aug 2013 20:17:21 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Grant Grundler <grundler@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, Tomasz Figa <t.figa@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
Message-id: <20130816201721.b93a6e3db960e38b29ca7b1a@samsung.com>
In-reply-to: <CANEJEGveOtGs8XEYFnnXoZ575bqKRkc3AMikr_1x02cNikwTng@mail.gmail.com>
References: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
 <1516548.d7oQuzQS7g@amdc1227>
 <CANEJEGu1ponghpfvyUsQX16+TZWUV+0KXJ7AehjXpju2N_H+Ew@mail.gmail.com>
 <20130814104938.GF4491@8bytes.org>
 <CANEJEGveOtGs8XEYFnnXoZ575bqKRkc3AMikr_1x02cNikwTng@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zI10nLr4gg/dX2C3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jN4sDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpoX1xY0CRc0bP7AlsD4wz+LkZODgkBE4nnLavZIGwx
	iQv31gPZXBxCAssYJR7NfcAIU9Q79SoLRGIRo8SpabcYIZxJTBLT911hAqliEVCVePHtJzuI
	zSagJbF67nGwbhEge8b+c6wgDcwCN1gk/p9aB+RwcAgLuEm0HhMEqeEVcJRY/L2FHSTMKRAs
	MemYEcT8HiaJ5Ye72CGusJC40NTBDlEvKPFj8j0WEJsZaP7mbU2sELa8xOY1b5lBmiUEFnJI
	nJ26mQXiOAGJb5MPsYAskBCQldh0gBlipqTEwRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0tSC5
	oDgpvchIrzgxt7g0L10vOT93EyMk1vt2MN48YH2IMRlo5URmKdHkfGCqyCuJNzQ2M7IwNTE1
	NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY83jXP+dwefNwlvK2F7s
	V3Tbw9d1f3VC4o7jfB2iL1u9Ku0Xu+UrTdqt/J/lb9fEY3LBL+2P9Qb75LxszJyS5OTSH39v
	8yOdJZtYMlccu8/u8dzSulhv33O7lVxBWc6t377+l7rRGxV0xXKh1g9BXqkp2w7HKj25fWf6
	vNqOS+naYscZHyVtVGIpzkg01GIuKk4EAGf4WycLAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jAV0nLr4gg5WvGS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jN4sDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0b64sKBJuKJn
	9wW2BsYZ/F2MnBwSAiYSvVOvskDYYhIX7q1n62Lk4hASWMQocWraLUYIZxKTxPR9V5hAqlgE
	VCVefPvJDmKzCWhJrJ57nBHEFgGyZ+w/xwrSwCxwg0Xi/6l1QA4Hh7CAm0TrMUGQGl4BR4nF
	31vYQcKcAsESk44ZQczvYZJYfriLHeIKC4kLTR3sEPWCEj8m3wO7jhlo/uZtTawQtrzE5jVv
	mScwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnkmdSOxhXNlgc
	YhTgYFTi4WWYyBskxJpYVlyZe4hRgoNZSYR3ykOgEG9KYmVValF+fFFpTmrxIcZkYGhMZJYS
	Tc4HJrm8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCs0Zt1
	7PvKX+GTfKasiJ+nFDPjXtT07lf/1/0oLDKYMdFBbqZ0Ssz5lVPmRijsM6lSvN9y4ffG/olW
	N24fSNoSVziFvV5mruDvpMVRNjZZUzr/sk3Sufb/sPvxo+XV1xnnzN7rx/Hy5OTw1LRWj2Zb
	p5W8kyx0m5oinrOuMtG79nLbvWklqfr7lViKMxINtZiLihMBhFJXIGgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 13:54:53 -0700, Grant Grundler wrote:
> On Wed, Aug 14, 2013 at 3:49 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Thu, Aug 08, 2013 at 11:28:44AM -0700, Grant Grundler wrote:
> >> I can't speak to the previous BUG_ON(). I believe the EADDRESSINUSE
> >> failures could be either WARN_ON or BUG_ON.   This condition is
> >> clearly a bug in the generic IOMMU allocator and I think that's why
> >> KyongHo Cho used BUG_ON.
> >>
> >> Handing out duplicate addresses will generally lead to some sort of
> >> data corruption or other fault depending on how robust the underlying
> >> device drivers are written.  So my preference is a BUG_ON to
> >> immediately flag this condition instead of hoping a device driver will
> >> correctly handling the dma mapping failure (Some do, most currently
> >> don't).
> >>
> >> WARN_ON() + return -EADDRESSINUSE would be a good alternative.
> >
> > Even if it is a real BUG condition, I don't think it is worth to stop
> > execution at this point. It makes debugging harder and the system less
> > reliable. I prefer to go with the WARN_ON and an error return value.
> 
> I'm ok with WARN_ON and an error return value. This is "valid"
> behavior.  I expect this bug to never happen but if and when it does,
> I want a clear symptom (e.g. WARN_ON) that it happened.
> 

Ok.
Finally, everyone thinks that WARN_ON() is OK.
It will be helpful for the kernel code that uses iommu api.

> My concern is that historically, drivers did not get an error return
> value on failure:
>     ftp://193.166.3.4/pub/linux/kernel/v2.3/patch-html/patch-2.3.47/linux_Documentation_DMA-mapping.txt.html
> 
> or later:
>     https://www.kernel.org/pub/linux/kernel/people/marcelo/linux-2.4/Documentation/DMA-mapping.txt
> 
> And thus, some drivers don't check or attempt to handle mapping
> failures based on this existing code. Here is a recent example:
>      http://comments.gmane.org/gmane.linux.network/272969
> 
> I hope very few or none of those exist since Neil Horman demonstrated
> "dma debugging" can flag this behavior.
> 
> Just for fun, I'll include this link : (apperently 2003 was a good
> year for DMA talks :)
>      http://ols.fedoraproject.org/OLS/Reprints-2003/LinuxSymposium2003-2side.pdf
>      (three talks on DMA issues)
> 

Thank you for the resources :)
Those will be helpful for the guys with me.

> thanks
> grant
