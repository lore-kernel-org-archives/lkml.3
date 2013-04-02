Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3DBWJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:09:35 -0400
Received: from 8bytes.org ([85.214.48.195]:54595 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab3DBWJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:09:34 -0400
Date: Wed, 3 Apr 2013 00:09:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402220931.GV30540@8bytes.org>
References: <1364929514-3129-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364929514-3129-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Apr  3 00:09:32 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515b571c23671120564415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 02:05:14PM -0500, Suthikulpanit, Suravee wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> +static const char * const _type_field_encodings[] = {
> +	/* 00 */"Reserved",
> +	/* 01 */"Master Abort",
> +	/* 10 */"Target Abort",
> +	/* 11 */"Data Error",

In these arrays, please put the comments at the end of the line and
align them nicely like this:

	static const char * const _type_field_encodings[] = {
		"Reserved",		/* 00 */
		"Master Abort",		/* 01 */
		"Target Abort",		/* 10 */
		"Data Error",		/* 11 */
	};

This improves readability a lot.

> +static void dump_flags(int flags, int ev_type)
> +{
> +	struct _event_log_flags *p = (struct _event_log_flags *) &flags;
> +	u32 err_type = p->type;
> +
> +	pr_err("AMD-Vi: Flags details: %s, NX:%u, %s, %s, %s, %s, %s, %s, %s\n",
> +		(p->gn ? "Use guest address" : "Use nested address"),
> +		(p->nx),
> +		(p->us ? "User privileges" : "Supervisor privileges"),
> +		(p->i ? "Interrupt request" : "memory request"),
> +		(p->pr ? "Page present or Interrupt remapped" :
> +			"Page not present or Interrupt blocked"),
> +		(p->rw ? "Write transaction" : "Read transaction"),
> +		(p->pe ? "Does not have permission" : "Has permission"),
> +		(p->rz ? "Reserv bit not zero" : "Illegal level encoding"),
> +		(p->tr ? "Translation request" : "Transaction request"));

These strings are too long, please just print useful shortcuts for them,
like
	"US" : "SV" instead of
	"User privileges" : "Supervisor privileges"

Also the commas between the strings are not needed then.

As a general rule, in the default configuration an event-log entry
should not take more than a single line in dmesg (which is also not too
long). If you want to print more information in some cases you can
enable that by a command line parameter like 'amd_iommu=verbose' or
something like that.

	Joerg

