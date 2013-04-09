Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937058Ab3DIQAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:00:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57084 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936290Ab3DIQAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:00:38 -0400
Message-ID: <1365523237.6865.40.camel@joe-AO722>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 09 Apr 2013 09:00:37 -0700
In-Reply-To: <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 05:46 -0700, Jacob Pan wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions.

yet more trivia:

> diff --git a/drivers/platform/x86/intel_rapl.c b/drivers/platform/x86/intel_rapl.c
[]
> +static bool rapl_polling_should_cont(void)
> +{
> +	unsigned int all_state = 0;
[]
> +	return !!all_state;

The !! isn't needed.
!! should only be done when you are returning
int and you need to make sure it's 0 or 1.
It's not here.  The return is bool.

	return all_state;

The compiler, even icc, will do this internally.

> +static int start_periodic_polling(void)
> +{
> +	if (polling_started)
> +		goto out;
> +	schedule_delayed_work(&rapl_polling_work, 0);
> +	polling_started = true;

Should polling_started be device specific (in struct rapl_data ?)
instead of a single instance static?


