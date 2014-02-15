Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaBOUN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:13:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaBOUNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:13:55 -0500
Date: Sat, 15 Feb 2014 12:15:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH v2 03/11] sysfs: create bin_attributes under the
 requested group
Message-ID: <20140215201515.GA28316@kroah.com>
References: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
 <1392415338-16288-4-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392415338-16288-4-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:02:07PM -0800, Cody P Schafer wrote:
> bin_attributes created/updated in create_files() (such as those listed
> via (struct device).attribute_groups) were not placed under the
> specified group, and instead appeared in the base kobj directory.
> 
> Fix this by making bin_attributes use creating code similar to normal
> attributes.
> 
> A quick grep shows that no one is using bin_attrs in a named attribute
> group yet, so we can do this without breaking anything in usespace.
> 
> Note that I do not add is_visible() support to
> bin_attributes, though that could be done as well.

is_visible() support would be nice to add if you get a chance.

thanks,

greg k-h
