Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3IXO0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:26:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63121 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IXO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:26:15 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-6a-5241a104769a
From: Tomasz Figa <t.figa@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, rjw@sisk.pl,
        kgene.kim@samsung.com, viresh.kumar@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, mturquette@linaro.org,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        t.stanislaws@samsung.com, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v5 1/3] clk: samsung: Add clock driver for s5pc110/s5pv210
Date: Tue, 24 Sep 2013 16:26:01 +0200
Message-id: <2095838.ED3sWFjloW@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <52419A6E.9020203@samsung.com>
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1380027009-2239-2-git-send-email-m.krawczuk@partner.samsung.com>
 <52419A6E.9020203@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/xa7osCx2DDLZuN7bYOGM9q8WkdQeY
	LJ42/WC3mH/kHKvFuVcrGS16F1xlszjb9IbdYtPja6wWC9uWsFhc3jWHzeJz7xFGixnn9zFZ
	3L7Ma3F6zSlmi7VH7rJbLL1+EWjIhItsFhOmr2Wx6F/Yy2RxeAXQ4HUvp7NYHH7Tzmrx6mAb
	i8W89pesFsdmLGG0WLXrD6PFxq8eDtIea+atYfRoae5h81jw+Qq7x99VL5g9ds66y+6xcvkX
	No9Xq2eyety5tofNY/OSeo+D7/YwefRtWcXo8WhxC6PH501yHhvnhgbwRXHZpKTmZJalFunb
	JXBlvDn0i73gEWfFx09rWRsYP7N3MXJySAiYSHzseMQCYYtJXLi3nq2LkYtDSGApo8ScG/0s
	EE4Xk8SDVfNZQarYBNQkPjc8YgOxRQT0JZasugjWwSywj1VixeFjjCAJYQE/idu7boONZRFQ
	ldhwejlYM6+ApsSDeTPAVvMLqEu82/aUCcQWFXCV+LRwI1icU0Bb4t6rZqgzNjFK/F/xmAWi
	WVDix+R7YDazgLzEvv1TWSFsLYn1O48zTWAUnIWkbBaSsllIyhYwMq9iFE0tTS4oTkrPNdIr
	TswtLs1L10vOz93ECEkOX3cwLj1mdYhRgINRiYf3QoJDkBBrYllxZe4hRgkOZiURXs1axyAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjOUFs2xWndD5IrrCMS1Kr/Kh+vntTzbmb54bX8O4w9jH
	6nnw0Z1lrhzq38Kma9/iOSHx6EXIkUrNYMOpTv94NTe9TlyoeM467MHqr703Ux7ML1y8vK2k
	7d+COHv1VLmc05G8oo47beVtLr43Z39m+nn+kRU7611/p/sYTOOLfmHnmJqe82FrhBJLcUai
	oRZzUXEiAOcltszsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 of September 2013 15:58:06 Sylwester Nawrocki wrote:
> Hi,
> 
> On 24/09/13 14:50, Mateusz Krawczuk wrote:
> > +++ b/Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
> > @@ -0,0 +1,75 @@
> > +* Samsung S5PC110/S5PV210 Clock Controller
> > +
> > +The S5PV210 clock controller generates and supplies clock to various controllers
> > +within the SoC. The clock binding described here is applicable to all SoCs in
> > +the S5PC110/S5PV210 family.
> > +
> > +Required Properties:
> > +
> > +- compatible: should be "samsung,s5pv210-clock".
> 
> I have nothing against this compatible value, but wouldn't it be more
> accurate to use, e.g. "samsung,s5pv210-cmu" - for Clock Management Unit,
> as this IP block is also referred to in the documentation ?
> 
> May just be me, but "samsung,s5pv210-clock" sounds like just one
> specific clock type.

In the user's manual I have, this IP is referred to either as "CMU", as
you suggested, or simply as "clock controller". "CMU" is not very
meaningfull, so "samsung,s5pv210-clock-controller" would be the best here
I guess, but for consistency with other Samsung's clock bindings, I'd
suggest leaving this as is in the patch.

Best regards,
Tomasz

