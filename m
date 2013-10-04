Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3JDQvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:51:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3JDQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:51:21 -0400
Date: Fri, 4 Oct 2013 09:51:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        len.brown@intel.com, rjw@sisk.pl, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 2/6] PowerCap: Add class driver
Message-ID: <20131004165120.GA19892@kroah.com>
References: <1380904616-17519-1-git-send-email-srinivas.pandruvada@linux.intel.com>
 <1380904616-17519-3-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380904616-17519-3-git-send-email-srinivas.pandruvada@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:36:52AM -0700, Srinivas Pandruvada wrote:
> +/* Power zone ro attributes define */
> +#define powercap_attr_ro(_name)		\
> +	static DEVICE_ATTR(_name, 0444, show_##_name, NULL)
> +
> +/* Power zone rw attributes define */
> +#define powercap_attr_rw(_name)		\
> +	static DEVICE_ATTR(_name, 0644, show_##_name, store_##_name)
> +
> +/* constraint attributes define rw */
> +#define powercap_const_attr_rw(_name)		\
> +	static DEVICE_ATTR(_name, 0644, show_constraint_##_name, \
> +				store_constraint_##_name)
> +/* constraint attributes define ro */
> +#define powercap_const_attr_ro(_name)		\
> +	static DEVICE_ATTR(_name, 0644, show_constraint_##_name, NULL)

Minor nit:

Why are you using your own defines, why not just use the
DEVICE_ATTR_RO() and DEVICE_ATTR_RW() macros?  That way it makes it
easier to grep for attributes, and ensure they have set the mode bits
properly.

thanks,

greg k-h
