Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3KAHyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:54:47 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:8170 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3KAHyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:54:45 -0400
Date: Fri, 1 Nov 2013 01:54:39 -0600
From: jerry.hoemann@hp.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, hpa@linux.intel.com,
        ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131101075439.GB17713@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022220803.GA32387@anatevka.fc.hp.com>
 <526712B2.7070108@jp.fujitsu.com>
 <20131031005812.GA15459@anatevka.fc.hp.com>
 <20131031132744.GB3392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031132744.GB3392@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:27:45AM -0400, Vivek Goyal wrote:
> On Wed, Oct 30, 2013 at 06:58:13PM -0600, jerry.hoemann@hp.com wrote:
> 
> [..]
> > Daisuke,
> > 
> > Are you planning on making changes to the kexec tools to automate
> > the setting of disable_cpu_apic to the capture kernel? Or do you
> > know someone who is planning this?
> 
> I think we should not make this change in kexec-tools and should leave
> it to distro scripts to append disable_cpu_apic.
> 
> Who knows in future this restriction is not there at all and kexec-tools
> will be stuck with always passing disable_cpu_apic. Getting rid of
> this parameter in distro scripts will be much easier.
> 
> Thanks
> Vivek


I'm fine either way as long as there is a reasonable automated way to
pass this information to the capture kernel.

It is possible for the bsp to change from boot to boot.  So checking
the initial apic id of the bsp each boot will be necessary.  If it
changes the kdump initrd would need to change, correct?
If yes,  it would be good if the scripts can cache prior boot value
of bsp and avoid rebuilding the kdump initrd if the bsp doesn't change.


thanks

Jerry
-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

