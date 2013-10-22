Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3JVO5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:57:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34758 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3JVO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:57:46 -0400
Date: Tue, 22 Oct 2013 10:57:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Ian Campbell <ian.campbell@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022145724.GA18763@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 02:18:52PM +0000, Woodhouse, David wrote:
> 
> > I wonder why Linux can't make the EFI calls to fetch them itself?
> 
> It can. It does. It prefers to. This is what the "EFI boot stub" is all about. But grub2 is crack-inspired and likes to do all kinds of crap that it shouldn't. It is an exercise in complexity for complexity's sake. The 'linuxefi' method is actually not really Linux-specific; it just boots an EFI executable (which the bzImage *is* when compiled that way).

Perhaps I am reading the wrong code, but I am unable to find this
in the source.

I am looking in grub_cmd_linux in grub-core/loader/i386/efi/linux.c (Fedora 19 src RPM)
and I see:

                                                                               
  if (grub_file_read (file, &lh, sizeof (lh)) != sizeof (lh))                   
    {                                                                           
      if (!grub_errno)                                                          
        grub_error (GRUB_ERR_BAD_OS, N_("premature end of file %s"),            
                    argv[0]);                                                   
      goto fail;                                                                
    }                                                                           
                                                                                
  if (lh.boot_flag != grub_cpu_to_le16 (0xaa55))                                
    {                                                                           
      grub_error (GRUB_ERR_BAD_OS, N_("invalid magic number"));                 
      goto fail;                                                                
    }                                                                           
                                                                                
  if (lh.setup_sects > GRUB_LINUX_MAX_SETUP_SECTS)                              
    {                                                                           
      grub_error (GRUB_ERR_BAD_OS, N_("too many setup sectors"));               
      goto fail;                                                                
    }                                                                     
.. snip..

 if (!lh.handover_offset)                                                      
    {                                                                           
      grub_error (GRUB_ERR_BAD_OS, N_("kernel doesn't support EFI handover"));  
      goto fail;                                                                
    }                   


Which would imply that the header MUST have a Linux x86/boot header.

Which GRUB2 module can boot an non-Linux x86/boot header?

> 
> Seriously, forget bootloaders (especially grub2) and make it a COFF/PE executable.  Then everything should just work, including Secure Boot etc.
> 
> And bootloaders can still load that, of course.

That 'that' is a standard PE/COFF image?  Could you please point me
to the code that does that in GRUB2?

Thanks!
