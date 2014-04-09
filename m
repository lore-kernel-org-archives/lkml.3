Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaDIIDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:03:47 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57346 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaDIIDn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 Apr 2014 04:03:43 -0400
Message-Id: <53451AFB0200007800006FC9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 09 Apr 2014 09:03:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <konrad@kernel.org>
Cc: <david.vrabel@Citrix.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [LINUX PATCH 2/2] xen/pvhvm: Support more than 32 VCPUs
 when migrating.
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-3-git-send-email-konrad@kernel.org>
In-Reply-To: <1396977950-8789-3-git-send-email-konrad@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote:
> +	/* Only Xen 4.5 and higher supports this. */
> +	if (HYPERVISOR_vcpu_op(VCPUOP_is_up, smp_processor_id(), NULL) == -ENOSYS)
> +		vcpuops = false;

Did you mean to say "for HVM guests" in the comment? And of
course the comment could quickly become stale if we backported
the Xen side change to e.g. 4.4.1.

Jan

