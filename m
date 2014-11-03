Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaKCPV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:21:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaKCPVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:21:55 -0500
Date: Mon, 3 Nov 2014 10:21:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        jbaron@akamai.com, hedi@sgi.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v6] kernel, add panic_on_warn
Message-ID: <20141103152116.GB22503@redhat.com>
References: <1415025143-4345-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415025143-4345-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 09:32:23AM -0500, Prarit Bhargava wrote:

[..]
> +
> +static int __init panic_on_warn_setup(char *s)
> +{
> +	/* Enabling this on a kdump kernel could cause a bogus panic. */
> +	if (!is_kdump_kernel())
> +		panic_on_warn = 1;

I think it would be better if we leave it to user space to remove
panic_on_warn from command line of second kernel.

Thanks
Vivek
