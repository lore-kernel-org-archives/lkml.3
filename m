Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3AQNFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:05:06 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:54581 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3AQNFE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 17 Jan 2013 08:05:04 -0500
Message-Id: <50F8050C02000078000B6D33@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 17 Jan 2013 13:05:00 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Wilson" <msw@amazon.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xensource.com>, <annie.li@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/grant-table: Force to use v1 of
 grants.
References: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
 <20130117110829.GA21859@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20130117110829.GA21859@u109add4315675089e695.ant.amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.01.13 at 13:22, Matt Wilson <msw@amazon.com> wrote:
> On Wed, Jan 16, 2013 at 04:22:49PM -0500, Konrad Rzeszutek Wilk wrote:
>> We have the framework to use v2, but there are no backends that
>> actually use it. The end result is that on PV we use v2 grants
>> and on PVHVM v1. The v1 has a capacity of 512 grants per page while
>> the v2 has 256 grants per page. This means we lose about 50%
>> capacity - and if we want more than 16 VIFs (each VIF takes
>> 512 grants), then we are hitting the max per guest of 32.
>> 
>> Note: The hypervisor provides an over-ride for the default
>> of 32 frames (pages) per guest: gnttab_max_nr_frames=X
> 
> I think it would be better if the dom0/service domain and hypervisor
> prevent the guest from setting the version to 2 if the backend isn't
> going to make use of them. In the short term, we could add a Xen
> option to limit the supported version to 1.

But that's something each guest has to decide for itself.

Anyway - if no-one's using v2, what did it get introduced for
(not only in the hypervisor, but also in the kernel)? I thought
the networking drivers were intended to make use of it...

Jan

