Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaC0L0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:26:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55164 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaC0L0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:26:16 -0400
Date: Thu, 27 Mar 2014 16:56:03 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: don't print value of .driver_data from core
Message-ID: <20140327112602.GD27777@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <2490cd0aaeaaeb88131c8089d491c485f08da5da.1395914766.git.viresh.kumar@linaro.org>
 <20140327104842.GB27777@in.ibm.com>
 <CAKohpombz9jzAs-_mpBNJyTJrrvvXVQ1L0V8fyKmB1vXpSPjmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpombz9jzAs-_mpBNJyTJrrvvXVQ1L0V8fyKmB1vXpSPjmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032711-3532-0000-0000-0000009A5F55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 04:29:37PM +0530, Viresh Kumar wrote:
> On 27 March 2014 16:18, Gautham R Shenoy <ego@linux.vnet.ibm.com> wrote:
> > So after this patch, driver_data is only going to be used by drivers
> > which want an "unsigned int" value to be saved along with the
> > frequency in the frequency_table and for those who want to overload
> > its interpretation to indicate BOOST.
> >
> > From the core's stand point, it is useful only for determining whether
> > a frequency is BOOST frequency or not.
> 
> Yes.
> 
> > So, wouldn't it be logical to allow drivers maintain their own driver
> > data since the core is anyway not interested in it, and change this
> > .driver_data to "flags" or some such which can indicate boost ?
> 
> We can add another field .flags in case Rafael doesn't accept the
> other proposal I sent for fixing BOOST issue.

Even with that patch, the .driver_data won't be opaque. And that's not
good. Because, while some driver might not be explicitly setting the
value of .driver_data to 0xABABABAB, it might want to store the value
obtained at runtime into this field. And it could so happen
that at runtime this value is 0xABABABAB.

> 
> But the point behind keeping .driver_data field here was: many drivers
> have some information attached to each frequency and they are closely
> bound to each other. And so it made more sense to keep them together.
> This is still used by many drivers and I wouldn't like them to maintain
> separate arrays for keeping this information. They are so much bound
> to the frequencies at the same index, that keeping them separately
> wouldn't be a good idea.

I understand this part. However there might be more data than an
"unsigned int" that the drivers would like to be bound at the same
index. Voltage information, for instance.

> 
--
Thanks and Regards
gautham.

