Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaJ1Mmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:42:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29566 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJ1Mmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:42:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,802,1406592000"; 
   d="scan'208";a="186835850"
Message-ID: <544F8F3A.3030505@citrix.com>
Date: Tue, 28 Oct 2014 12:42:34 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, Juergen Gross <jgross@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: <boris.ostrovsky@oracle.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0/2] xen: Switch to virtual mapped linear
 p2m list
References: <1414421551-31555-1-git-send-email-jgross@suse.com>	<544E61DD.8050305@citrix.com>	<544F22E4.9040706@suse.com> <1414489898.23883.25.camel@citrix.com> <544F83C1.3010402@citrix.com> <544F8713.9040803@suse.com> <544F8E89.6070006@citrix.com>
In-Reply-To: <544F8E89.6070006@citrix.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 12:39, David Vrabel wrote:
> On 28/10/14 12:07, Juergen Gross wrote:
>> Okay, back to the original question: is the (up to) 64 MB virtual
>> mapping of the p2m list on 32-bit pv domains a problem or not?
> I think up-to 64 MiB of vmalloc area is fine.  The vmalloc space can be
> increased with a command line option in the unlikely event that there
> are domUs that would be affected.
>
>> If yes, the virtual mapped linear p2m list could still be used on
>> 64 bit domains, paving the way for support of more than 512 GB of
>> domain memory. OTOH having to keep the p2m tree coding alive isn't
>> my favorite solution...
> Having to keep both the tree and linear p2m code would be awful.  Let's
> not do this!
>
> David

How is the toolstack expected to find and mutate this p2m on migrate? 
The toolstack does not use guest pagetables.

~Andrew
