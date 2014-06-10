Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaFJOxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:53:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54446 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaFJOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:53:49 -0400
Message-ID: <1402412021.5350.53.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin
 keys only
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, dhowells@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        mjg59@srcf.ucam.org
Date: Tue, 10 Jun 2014 10:53:41 -0400
In-Reply-To: <20140610132918.GD31944@hansolo.jdub.homelinux.org>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <cover.1402387862.git.d.kasatkin@samsung.com>
	 <20140610122008.GA31944@hansolo.jdub.homelinux.org>
	 <1402404750.5350.7.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53970660.4030101@samsung.com>
	 <20140610132918.GD31944@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061014-1542-0000-0000-00000278773A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 09:29 -0400, Josh Boyer wrote: 
> On Tue, Jun 10, 2014 at 04:21:36PM +0300, Dmitry Kasatkin wrote:
> > On 10/06/14 15:52, Mimi Zohar wrote:
> > > On Tue, 2014-06-10 at 08:20 -0400, Josh Boyer wrote: 
> > >> On Tue, Jun 10, 2014 at 11:48:14AM +0300, Dmitry Kasatkin wrote:
> > >>> Also I want to discuss here Fedora UEFI patches as they are the reason for
> > >>> the these original patchset.
> > >>>
> > >>> http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch
> > >>>
> > >>> They provide functionality to specify MokIgnoreDb variable to limit loading of
> > >>> UEFI keys only from MOK List, while ignoring DB. This is certainly a good
> > >>> functionality. But once MODULE_SIG_UEFI is enabled, it looks there is no way
> > >>> to prevent loading keys from UEFI at all. And this might not be a good default
> > >>> functionality. Someone might want not allow loading of keys from UEFI unless
> > >>> kernel parameter is specified to allow it without recompiling the kernel
> > >>> and disabling MODULE_SIG_UEFI.
> > >>>
> > >>> Josh, why such design decision was made?
> > >> IIRC, it's because kernel parameters can be added programmatically from a
> > >> remote user if they gain root access.  Having a kernel parameter to
> > >> disable a key piece of secure boot isn't all that great.  We disable
> > >> other kernel parameters like acpi_rspd as well.
> > > In this case, there shouldn't be a problem as the kernel parameters
> > > would further limit the keys usage.
> > >
> > > Mimi
> > 
> > Josh probably means that it can be removed and restriction is lifted..
> > And after reboot, all keys come to the keyring..
> 
> Right.  Or if we went with your suggestion of the default being "do not
> load UEFI keys", then they could conversely add the parameter instead.
> This might not be an immediate threat to the SB attack vector itself
> (thought it could be if I thought about it harder), but it's certainly
> a change in system behavior that would catch a user unaware.

Agreed, it could catch the user unaware of the change, but always
allowing all the UEFI keys, is not a better alternative.  Perhaps,
requiring the option, would at least prevent the user from being unaware
of the change.

Mimi

> At any rate, I'm likely not the best person to weigh in on this aspect.
> Matthew has certainly done more thinking about these kinds of problems.
> 
> josh


