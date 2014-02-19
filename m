Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBSIU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:20:28 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64100 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBSIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:20:23 -0500
Date: Wed, 19 Feb 2014 00:20:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ppc: RECLAIM_DISTANCE 10?
In-Reply-To: <20140219081644.GA14783@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1402190017480.7280@chino.kir.corp.google.com>
References: <20140218090658.GA28130@dhcp22.suse.cz> <alpine.DEB.2.02.1402181424490.20772@chino.kir.corp.google.com> <20140219081644.GA14783@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Michal Hocko wrote:

> > I strongly suspect that the patch is correct since powerpc node distances 
> > are different than the architectures you're talking about and get doubled 
> > for every NUMA domain that the hardware supports.
> 
> Even if the units of the distance is different on PPC should every NUMA
> machine have zone_reclaim enabled? That doesn't right to me.
> 

In my experience on powerpc it's very correct, there's typically a 
significant latency in remote access and we don't have the benefit of a 
SLIT that actually defines the locality between proximity domains like we 
do on other architectures.  We have had significant issues with thp, for 
example, being allocated remotely instead of pages locally, much more 
drastic than on our x86 machines, particularly AMD machines.
