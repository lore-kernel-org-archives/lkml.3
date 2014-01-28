Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaA1Ogg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:36:36 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:32897 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaA1Ogf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:36:35 -0500
Message-ID: <52E7C06F.3010205@linaro.org>
Date: Tue, 28 Jan 2014 14:36:31 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, ian.campbell@citrix.com,
        patches@linaro.org
Subject: Re: [PATCH] xen/events: xen_evtchn_fifo_init can be called very late
References: <1390869269-12502-1-git-send-email-julien.grall@linaro.org> <52E787FA.3080105@citrix.com> <alpine.DEB.2.02.1401281406090.4373@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1401281406090.4373@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:30 PM, Stefano Stabellini wrote:
> On Tue, 28 Jan 2014, David Vrabel wrote:
>> On 28/01/14 00:34, Julien Grall wrote:
>>> On ARM, xen_init_IRQ (which calls xen_evtchn_fifo_init) is called after
>>> all CPUs are online. It would mean that the notifier will never be called.
>>
>> Why does ARM call xen_init_IRQ() so late?  Is it possible to call it
>> earlier when only the boot CPU is online?  There are problems with
>> attempting to init FIFO event channels after all CPUs are online.
>>
>> If evtchn_fifo_init_control_block(cpu) fails on anything other than the
>> first CPU, that CPU will be unable to receive any events.  Xen will have
>> been switched to FIFO mode and it is not possible to revert back to
>> 2-level mode.
> 
> We simply didn't need to be called that early.
> Most of xen_guest_init could be moved to an early_initcall, if that is
> necessary.
> 

I'm actually working on a patch to move xen_init_IRQ() in early_initcall.

-- 
Julien Grall
