Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaLDLgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:36:37 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:50495 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaLDLgg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 4 Dec 2014 06:36:36 -0500
Message-Id: <54805552020000780004CAD4@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 04 Dec 2014 11:36:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: <bhelgaas@google.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v5 8/9] xen-pciback: drop SR-IOV VFs when PF driver
 unloads
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
 <1417642834-20350-9-git-send-email-konrad.wilk@oracle.com>
 <5480407F.7070402@citrix.com>
In-Reply-To: <5480407F.7070402@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.12.14 at 12:07, <david.vrabel@citrix.com> wrote:
> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote:
>> From: Jan Beulich <JBeulich@suse.com>
>> 
>> When a PF driver unloads, it may find it necessary to leave the VFs
>> around simply because of pciback having marked them as assigned to a
>> guest. Utilize a suitable notification to let go of the VFs, thus
>> allowing the PF to go back into the state it was before its driver
>> loaded (which in particular allows the driver to be loaded again with
>> it being able to create the VFs anew, but which also allows to then
>> pass through the PF instead of the VFs).
>> 
>> Don't do this however for any VFs currently in active use by a guest.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> [v2: Removed the switch statement, moved it about]
>> [v3: Redid it a bit differently]
> 
> Jan, are you happy with Konrad's change now?

Yes: http://lists.xenproject.org/archives/html/xen-devel/2014-12/msg00267.html

Jan

