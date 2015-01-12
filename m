Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbbALVwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:52:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:1765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbALVwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:52:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,745,1413270000"; 
   d="scan'208";a="668674137"
Message-ID: <54B44210.4090608@intel.com>
Date: Mon, 12 Jan 2015 13:52:16 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: riel@redhat.com, linux-kernel@vger.kernel.org
CC: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: Re: [RFC PATCH 01/11] x86,fpu: document the data structures a little
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-2-git-send-email-riel@redhat.com>
In-Reply-To: <1421012793-30106-2-git-send-email-riel@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 01:46 PM, riel@redhat.com wrote:
> +/*
> + * The FPU state used depends on the capabilities of the hardware; the
> + * registers used for vector instructions on newer hardware are included
> + * in the FPU state.
> + */
>  union thread_xstate {

Tiny nit, if you happen to revise this set at some point...

While you probably don't need/want to have an exhaustive list of
everything that gets saved in there, we should probably still mention
that it's a lot more than just vector instructions.

I'd say:

	The FPU state used depends on the capabilities of the
	hardware.  This state increasingly contains things
	not related to the FPU itself, like registers used for
	vector instructions.
