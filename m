Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab3CSIOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:14:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38324 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab3CSIOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:14:51 -0400
Message-ID: <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 08:14:45 +0000
In-Reply-To: <20130319014850.GA28934@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
	 <20130319014850.GA28934@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 01:48 +0000, Matthew Garrett wrote:
> On Mon, Mar 18, 2013 at 08:40:14AM +0000, James Bottomley wrote:
> 
> > The object here is to make the NV+BS variables accessible (at least read only)
> > at runtime so we can get a full picture of the state of the EFI variables for
> > debugging and secure boot purposes.
> 
> I'd really prefer not to do this - the reason these aren't flagged as RT 
> is that they're not supposed to be visible at runtime and may break 
> certain security assumptions.

I suppose they could be flagged as read only by root, but I haven't seen
anything non-innocuous in them yet.  It's mostly shell redirects and a
bit more useful information about the secure boot configuration.

Any security assumptions that rely on inability to read certain
information aren't really going to be that secure.  Inability to modify,
sure, but inability to read, not really.

>  If there's a real development purpose to 
> this then it ought to be guarded as a config option.

I've no objection to them going under the secure boot lockdown config
option if that's what you're thinking.

James


