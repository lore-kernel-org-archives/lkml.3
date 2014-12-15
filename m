Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaLOSHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:07:51 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55978 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaLOSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:06:57 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tomasz Figa <tfiga@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "open list\:ARM\/Rockchip SoC..." 
	<linux-rockchip@lists.infradead.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Heiko Stuebner <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
	<7h8uiemce7.fsf@deeprootsystems.com>
	<CAPDyKFo6zH4__Odm+RiJCbvXquAQqaLyCAiXrSN6s3KfQhok=A@mail.gmail.com>
	<1576771.dIVCOxU0se@vostro.rjw.lan>
	<CAAFQd5B28WiWUqmbmROJUa3H25R=Y774NuemTZDvkoa=CvZUsw@mail.gmail.com>
	<7ha92sk533.fsf@deeprootsystems.com>
	<CAMuHMdVpCgK-hNqZ=JWjFGS53g+ZUQ5t=uBxtN1qGXJhoRg8BQ@mail.gmail.com>
Date: Mon, 15 Dec 2014 10:06:51 -0800
In-Reply-To: <CAMuHMdVpCgK-hNqZ=JWjFGS53g+ZUQ5t=uBxtN1qGXJhoRg8BQ@mail.gmail.com>
	(Geert Uytterhoeven's message of "Mon, 15 Dec 2014 09:35:09 +0100")
Message-ID: <7hr3w0iy84.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Fri, Dec 12, 2014 at 9:04 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> An even more exciting problem exists when a CPU is in the same domain as
>> other peripherals, those peripherals are all idle and the power domain
>> is gated. :)
>
> We do have pm_genpd_attach_cpuidle() and pm_genpd_name_attach_cpuidle()?

Exactly.  

And I think to solve this problem, we need to generalize the attaching
of dependent devices to a PM domain.

Kevin
