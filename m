Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbbAVNIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:08:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:47498 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbbAVNIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,448,1418112000"; 
   d="scan'208";a="640982024"
Date: Thu, 22 Jan 2015 15:05:49 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] driver core: property: support for generic property
Message-ID: <20150122130549.GA30522@kuha.fi.intel.com>
References: <1421150428-10191-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421150428-10191-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 13, 2015 at 02:00:28PM +0200, Heikki Krogerus wrote:
> +/**
> + * struct dev_gen_prop - Generic Device Property
> + * @name: property name
> + * @val: value array
> + *
> + * Used when of_node and acpi_node are missing.
> + */
> +struct dev_gen_prop {
> +	enum dev_prop_type type;
> +	const char *name;
> +	const char **val;
> +};

I'm going to do one more change to this.

Mika proposed we should have an array of strings and numbers in this
structure instead of just strings. It will make delivering things like
flags much easier.

The structure will then look like this:

struct dev_gen_prop {
	enum dev_prop_type type;
	const char *name;
        size_t nval;
	const char **str;
	u64 *num;
};

Cheers,

-- 
heikki
