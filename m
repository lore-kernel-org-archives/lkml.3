Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaKXOZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:25:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46536 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaKXOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:25:03 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-33-54733fbc687f
Date: Mon, 24 Nov 2014 15:24:49 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] thermal:core:fix: Check return code of the
 ->get_max_state() callback
Message-id: <20141124152449.595d5d34@amdc2363>
In-reply-to: <CAKohpok3pTEk05L7t+o6BYoODnBboAegg1o9dAj8=VOk8G7odQ@mail.gmail.com>
References: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1416305790-27746-1-git-send-email-l.majewski@samsung.com>
 <20141121180826.GA3331@developer> <20141124113854.36975fb2@amdc2363>
 <CAKohpok3pTEk05L7t+o6BYoODnBboAegg1o9dAj8=VOk8G7odQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jQd099sUhBvdfKVlsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbXF51xw2i8+9RxgtOr/MYrN4cHUam8WTh31sFq8O
	trFY/Nw1j8Xi2IkZrBYbv3o4CHg82XSR0WPnrLvsHov3vGTyuHNtD5vHumlvmT0OTD7H6tHb
	/I7N49uZiSwefVtWMXo8/bGX2ePzJjmPjXNDA3iiuGxSUnMyy1KL9O0SuDI+fHnPWLCKreJI
	/wL2BsZ+1i5GTg4JAROJY/dnskPYYhIX7q1n62Lk4hASmM4o8eJCEyuE84tR4snDlWBVLAKq
	Es8/bmYEsdkE9CQ+333K1MXIwSEioCXx8mYqSD2zwClWic0dc5hAaoQF4iUubmgF28YLVN/0
	5S0LiM0pECzxZcEXJogFE5kkZv/8BlbELyAp0f7vBzPESXYS5z5tYIdoFpT4MfkeWDMz0LLN
	25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQI
	jsxn0jsYVzVYHGIU4GBU4uGdsb4oRIg1say4MvcQowQHs5IIr5hYcYgQb0piZVVqUX58UWlO
	avEhRmkOFiVx3hs3c0OEBNITS1KzU1MLUotgskwcnFINjHrs3zNeyas35lpH8LBsLj71wHry
	DbHXL53/qK/Z1/FIxUB6kf2mC9dXsvBv890bVirYzypX8EHlfLbEB8ug4pv3VtRXb2reePLF
	z8f3ZDrlbtdOW9qe4R2g6MVx/wnnBnfJxtTfvsZaV55ZzgjP72R0W3Te93CoNO81ic/LN5gV
	P+5ik5ezUmIpzkg01GIuKk4EAEsCcJPIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 24 November 2014 at 16:08, Lukasz Majewski
> <l.majewski@samsung.com> wrote:
> > As I look into the cpufreq-dt.c driver - in the cpufreq_init()
> > function, the call to of_cpufreq_cooling_register() is performed
> > just before cpufreq_table_validate_and_show().
> > It looks like a mistake in the cpufreq-dt.c code.
> 
> Yes. Just fixed it up and sent a patch. Please provide your
> tested-by's..

Thanks for your prompt response. I don't have board which uses both
of-thermal.c and cpufreq-dt.c (exynos uses old approach for cpufreq).

I think that Eduardo may have some boards for testing.

Regarding the patch:
Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
