Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947062Ab3BHW5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:57:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38838 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760362Ab3BHW5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:57:39 -0500
Date: Fri, 8 Feb 2013 22:57:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer
	from integer of different size
Message-ID: <20130208225727.GZ17833@n2100.arm.linux.org.uk>
References: <51143ca4.bNX7TobZ2rDrz0zj%fengguang.wu@intel.com> <511460B7.4030007@linux.intel.com> <20130208152858.GU17833@n2100.arm.linux.org.uk> <511530AC.1070203@linux.intel.com> <20130208185057.GK9135@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130208185057.GK9135@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 08:50:57PM +0200, Ville Syrjälä wrote:
> 	struct {
> 		uint8_t sika1;
> 		uint16_t sika2;
> 		uint32_t sika4;
> 		uint64_t sika8;

Note - you also need to check what the behaviour is with a pointer type
too - that's the one that gets ARM if you try this.  My test set on ARM
was:

int test_8(unsigned char *v, unsigned char *p)
{
        return get_user(*v, p);
}

int test_16(unsigned short *v, unsigned short *p)
{
        return get_user(*v, p);
}

int test_32(unsigned int *v, unsigned int *p)
{
        return get_user(*v, p);
}

int test_32_constp(unsigned int *v, const unsigned int *p)
{
        return get_user(*v, p);
}

int test_64(unsigned long long *v, unsigned long long *p)
{
        return get_user(*v, p);
}

int test_64_narrow(unsigned long *v, unsigned long long *p)
{
        return get_user(*v, p);
}

int test_ptr(unsigned int **v, unsigned int **p)
{
        return get_user(*v, p);
}

int test_wrong(char **v, const char **p)
{
        return get_user(*v, p);
}

All but the last should build cleanly and correctly.  The last should
issue a warning.
