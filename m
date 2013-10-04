Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3JDUHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:07:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:51668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab3JDUHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:07:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="388050203"
Message-ID: <524F1FE3.50404@linux.intel.com>
Date: Fri, 04 Oct 2013 13:06:59 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        len.brown@intel.com, rjw@sisk.pl, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 2/6] PowerCap: Add class driver
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com> <1380904616-17519-3-git-send-email-srinivas.pandruvada@linux.intel.com> <20131004165120.GA19892@kroah.com>
In-Reply-To: <20131004165120.GA19892@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 09:51 AM, Greg KH wrote:
> On Fri, Oct 04, 2013 at 09:36:52AM -0700, Srinivas Pandruvada wrote:
>> +/* Power zone ro attributes define */
>> +#define powercap_attr_ro(_name)		\
>> +	static DEVICE_ATTR(_name, 0444, show_##_name, NULL)
>> +
>> +/* Power zone rw attributes define */
>> +#define powercap_attr_rw(_name)		\
>> +	static DEVICE_ATTR(_name, 0644, show_##_name, store_##_name)
>> +
>> +/* constraint attributes define rw */
>> +#define powercap_const_attr_rw(_name)		\
>> +	static DEVICE_ATTR(_name, 0644, show_constraint_##_name, \
>> +				store_constraint_##_name)
>> +/* constraint attributes define ro */
>> +#define powercap_const_attr_ro(_name)		\
>> +	static DEVICE_ATTR(_name, 0644, show_constraint_##_name, NULL)
> Minor nit:
>
> Why are you using your own defines, why not just use the
> DEVICE_ATTR_RO() and DEVICE_ATTR_RW() macros?  That way it makes it
> easier to grep for attributes, and ensure they have set the mode bits
> properly.
I will replace in the next patchset.

Thanks,
Srinivas



