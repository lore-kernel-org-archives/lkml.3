Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab3DIXWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:22:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:32504 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab3DIXWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:22:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="292640463"
Date: Tue, 9 Apr 2013 16:22:13 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130409162213.44cffcac@chromoly>
In-Reply-To: <1365523237.6865.40.camel@joe-AO722>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<1365523237.6865.40.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013 09:00:37 -0700
Joe Perches <joe@perches.com> wrote:

> > +static int start_periodic_polling(void)
> > +{
> > +	if (polling_started)
> > +		goto out;
> > +	schedule_delayed_work(&rapl_polling_work, 0);
> > +	polling_started = true;  
> 
> Should polling_started be device specific (in struct rapl_data ?)
> instead of a single instance static?
hmmm, one of the future improvements is to add support for multi
package CPUs. I intend to use rapl_data for per package common data
across different domains but use a single polling thread to reduce
wakeups if we were to poll on multiple packages. So in that sense, I
want to keep the polling_started flag as a single instance within the
driver.

-- 
Thanks,

Jacob
