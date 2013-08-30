Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3H3Mt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab3H3Mt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:49:26 -0400
Date: Fri, 30 Aug 2013 08:48:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20130830124854.GA18156@redhat.com>
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
 <521F5297.4070906@linux.intel.com>
 <8738ps131z.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738ps131z.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 04:37:44PM -0700, Eric W. Biederman wrote:

[..]
> This situation is people who run machines of unreasonable size really
> would like to use multiple cpus when generating crash dumps.

Yes. Now kdump is in a phase where people are doing scalability work. And
one of the problems is that on mutli tera byte machines, filtering is
taking long time. With-in filtering it is especially the compression which
takes the longest (hatayama and cliff wickman have done some study here).

So Idea seems to be that bring up more cpus in the second kernel and try
to parallelize compression work and try to save dump time of multi tera
byte machines.

Thanks
Vivek
