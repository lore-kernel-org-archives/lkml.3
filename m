Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaFJN3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:29:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbaFJN3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:29:33 -0400
Date: Tue, 10 Jun 2014 09:29:18 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        mjg59@srcf.ucam.org
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
Message-ID: <20140610132918.GD31944@hansolo.jdub.homelinux.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
 <20140610122008.GA31944@hansolo.jdub.homelinux.org>
 <1402404750.5350.7.camel@dhcp-9-2-203-236.watson.ibm.com>
 <53970660.4030101@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53970660.4030101@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:21:36PM +0300, Dmitry Kasatkin wrote:
> On 10/06/14 15:52, Mimi Zohar wrote:
> > On Tue, 2014-06-10 at 08:20 -0400, Josh Boyer wrote: 
> >> On Tue, Jun 10, 2014 at 11:48:14AM +0300, Dmitry Kasatkin wrote:
> >>> Also I want to discuss here Fedora UEFI patches as they are the reason for
> >>> the these original patchset.
> >>>
> >>> http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch
> >>>
> >>> They provide functionality to specify MokIgnoreDb variable to limit loading of
> >>> UEFI keys only from MOK List, while ignoring DB. This is certainly a good
> >>> functionality. But once MODULE_SIG_UEFI is enabled, it looks there is no way
> >>> to prevent loading keys from UEFI at all. And this might not be a good default
> >>> functionality. Someone might want not allow loading of keys from UEFI unless
> >>> kernel parameter is specified to allow it without recompiling the kernel
> >>> and disabling MODULE_SIG_UEFI.
> >>>
> >>> Josh, why such design decision was made?
> >> IIRC, it's because kernel parameters can be added programmatically from a
> >> remote user if they gain root access.  Having a kernel parameter to
> >> disable a key piece of secure boot isn't all that great.  We disable
> >> other kernel parameters like acpi_rspd as well.
> > In this case, there shouldn't be a problem as the kernel parameters
> > would further limit the keys usage.
> >
> > Mimi
> 
> Josh probably means that it can be removed and restriction is lifted..
> And after reboot, all keys come to the keyring..

Right.  Or if we went with your suggestion of the default being "do not
load UEFI keys", then they could conversely add the parameter instead.
This might not be an immediate threat to the SB attack vector itself
(thought it could be if I thought about it harder), but it's certainly
a change in system behavior that would catch a user unaware.

At any rate, I'm likely not the best person to weigh in on this aspect.
Matthew has certainly done more thinking about these kinds of problems.

josh
