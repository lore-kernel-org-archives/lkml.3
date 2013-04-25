Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3DYJwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:52:45 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55347 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754310Ab3DYJwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:52:44 -0400
Date: Thu, 25 Apr 2013 04:52:42 -0500
From: Robin Holt <holt@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.de>, DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, "holt@sgi.com" <holt@sgi.com>
Subject: Re: memcpy_fromio in dmi_scan.c
Message-ID: <20130425095242.GT3658@sgi.com>
References: <1366636689.4503.35.camel@chaos.site>
 <5175FF0F.9050206@oracle.com>
 <1366702122.4667.11.camel@chaos.site>
 <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
 <1366831328.4618.476.camel@chaos.site>
 <3908561D78D1C84285E8C5FCA982C28F1EA53DAA@ORSMSX104.amr.corp.intel.com>
 <20130425020724.GR3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425020724.GR3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 09:07:24PM -0500, Robin Holt wrote:
> On Wed, Apr 24, 2013 at 08:16:50PM +0000, Luck, Tony wrote:
> > > That being said, "my" SN2 machine was previously running kernel 3.0.34
> > > which has the old dmi_scan code and it also said "DMI not present or
> > > invalid." Plus dmidecode fails on this machine with:
> > >
> > > /sys/firmware/efi/systab: SMBIOS entry point missing
> > >
> > > So it might as well be that DMI support on SN2 was already broken.
> > > Please let me know your findings on other SN2 machines.
> > 
> > I don't have an sn2 to test. Added Robin Holt to Cc list
> 
> I will try and boot an sn2 machine first thing tomorrow morning.
> I don't recall dmidecode being broken, but that was quite a while ago.
> I thought the license validation code we used on sn2 used data from the
> dmidecode output.

 # uname -r
3.0.13-0.27-default
 # dmidecode
# dmidecode 2.9
/sys/firmware/efi/systab: SMBIOS entry point missing


It looks like it is broken there as well.  This is running a SLES11SP2
kernel with no local changes.

dmesg show:
DMI not present or invalid.

Thanks,
Robin
