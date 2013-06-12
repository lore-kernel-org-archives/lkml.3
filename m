Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3FLAYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:24:17 -0400
Received: from www.sr71.net ([198.145.64.142]:47553 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3FLAYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:24:16 -0400
Message-ID: <51B7BFB0.8080401@sr71.net>
Date: Tue, 11 Jun 2013 17:24:16 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Youquan Song <youquan.song@linux.intel.com>
CC: Toshi Kani <toshi.kani@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        youquan.song@intel.com, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org
Subject: Re: cpu hotplug:  possible_cpus broken (again?) next-20130607
References: <51B79BE5.80804@sr71.net> <1637965.BN0HgQKvFj@vostro.rjw.lan> <51B7A1F8.6080507@sr71.net> <27437213.QrmAtijARn@vostro.rjw.lan> <1370989954.21540.4.camel@misato.fc.hp.com> <20130612120343.GA22109@linux-youquan.bj.intel.com>
In-Reply-To: <20130612120343.GA22109@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 05:03 AM, Youquan Song wrote:
> +#ifdef CONFIG_SMP
> +              /* return when cpu number greater than maximum number of
> CPUs */
> +               if (setup_max_cpus <= num_online_cpus() + 1) {
> +                       cpu_hotplug_driver_unlock();
> +                       return -EINVAL;
> +               }
> +#endif
>                 from_nid = cpu_to_node(cpuid);
>                 ret = cpu_up(cpuid);

Your patch is line-wrapped.

Also, the #ifdef is unnecessary.  If CONFIG_SMP is off:

	static const unsigned int setup_max_cpus = NR_CPUS;
	#define num_online_cpus() 1U

The compiler will take care of optimizing out the the if() without the
explicit #ifdef.

Also, the +1 looks goofy to me.  Doesn't this do the same thing (and
isn't it much easier to read)?

	if (num_online_cpus() >= setup_max_cpus)
