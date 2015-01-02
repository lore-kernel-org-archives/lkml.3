Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbbABPzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:55:16 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:58059 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbABPzP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 2 Jan 2015 10:55:15 -0500
Message-Id: <54A6BF5F02000078000C4AD1@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 02 Jan 2015 15:55:11 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] xen/x86: properly retrieve NMI reason
References: <54945D760200007800051157@mail.emea.novell.com>
 <54994B7B.20309@citrix.com>
In-Reply-To: <54994B7B.20309@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> David Vrabel <david.vrabel@citrix.com> 12/23/14 12:01 PM >>>
>On 19/12/14 16:16, Jan Beulich wrote:
>> Using the native code here can't work properly, as the hypervisor would
>> normally have cleared the two reason bits by the time Dom0 gets to see
>> the NMI (if passed to it at all). There's a shared info field for this,
>> and there's an existing hook to use - just fit the two together. Note
>> that the hook can (and should) be used irrespective of whether being in
>> Dom0, as accessing port 0x61 in a DomU would be even worse, while the
>> shared info field would just hold zero all the time.
>
>What's the user visible impact of this fix?

Depends on what "user visible" is: It ought to prevent "Dazed and confused..."
messages when not really applicable, and allow to get forwarded particularly
SERR ones to APEI (GHES) code instead. I can't say I've seen this work in
practice, as I lack ways to force SERR on otherwise well behaving hardware,
but code inspection shows that the way it is now it can't work as intended.

Jan

