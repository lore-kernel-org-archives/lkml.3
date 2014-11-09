Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaKID0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 22:26:38 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40839 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaKID0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 22:26:37 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 8 Nov 2014 19:26:30 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/ksize: Add kernel build size report
Message-ID: <20141109032630.GB1026@thin>
References: <eda7fd84192e80829af62db0a6debe6f1987f98b.1415488698.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eda7fd84192e80829af62db0a6debe6f1987f98b.1415488698.git.dvhart@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 03:18:18PM -0800, Darren Hart wrote:
> ksize generates hierarchical build size reports from vmlinux, *.o, and
> built-in.o files.
> 
> ksize is useful in preparing minimal configurations and comparing
> similar configurations across kernel versions.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Cc: Josh Triplett <josh@joshtriplett.org>

One comment below; with that addressed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> +def main(argv):
> +    try:
> +        opts, args = getopt.getopt(argv[1:], "dh", ["help"])
> +    except getopt.GetoptError, err:
> +        print '%s' % str(err)
> +        usage()
> +        return 2
> +
> +    driver_detail = False
> +    for o, a in opts:
> +        if o == '-d':
> +            driver_detail = True
> +        elif o in ('-h', '--help'):
> +            usage()
> +            return 0
> +        else:
> +            assert False, "unhandled option"
> +
> +    cols = term_width()
> +
> +    # Determine kernel version
> +    p = Popen("strings vmlinux | grep 'Linux version' | cut -d ' ' -f 3",
> +              shell=True, stdout=PIPE, stderr=PIPE)
> +    version = p.communicate()[0].strip()

This seems like a very fragile, Perl-y way to obtain the kernel version.

I'd suggest either not including the version (just as bloat-o-meter
doesn't), or parsing it out using objdump -h -t and file offsetting
(looking for the offset and size of linux_banner).  Personally I'd go
with the former.

- Josh Triplett
