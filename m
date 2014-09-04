Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaIDObu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:31:50 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:49577 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaIDObt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 4 Sep 2014 10:31:49 -0400
Message-Id: <540893F00200007800030E4F@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 04 Sep 2014 15:31:44 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooper" <andrew.cooper3@citrix.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>, <xen-devel@lists.xensource.com>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        "Juergen Gross" <JGross@suse.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: eliminate scalability issues
 from initial mapping setup
References: <1409834326-29287-1-git-send-email-jgross@suse.com>
 <1409834326-29287-4-git-send-email-jgross@suse.com>
 <54086244.7020601@citrix.com> <540862FE.7070108@citrix.com>
In-Reply-To: <540862FE.7070108@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.09.14 at 15:02, <andrew.cooper3@citrix.com> wrote:
> On 04/09/14 13:59, David Vrabel wrote:
>> On 04/09/14 13:38, Juergen Gross wrote:
>>> Direct Xen to place the initial P->M table outside of the initial
>>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>>> restriction on the size of the initial mapping limits the amount
>>> of memory a domain can be handed initially.
>> The three level p2m limits memory to 512 GiB on x86-64 but this patch
>> doesn't seem to address this limit and thus seems a bit useless to me.
> 
> Any increase of the p2m beyond 3 levels will need to come with
> substantial libxc changes first.  3 level p2ms are hard coded throughout
> all the PV build and migrate code.

No, there no such dependency - the kernel could use 4 levels at
any time (sacrificing being able to get migrated), making sure it
only exposes the 3 levels hanging off the fourth level (or not
exposing this information at all) to external entities making this
wrong assumption.

Jan

