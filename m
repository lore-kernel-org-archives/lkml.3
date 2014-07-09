Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaGINAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:00:04 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60805 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871AbaGINAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:00:01 -0400
Date: Wed, 9 Jul 2014 13:59:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>
Subject: v3.16-rc4 messes up make kernelrelease with additional output
Message-ID: <20140709125955.GS21766@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-rc3 and all previous versions:

$ make ARCH=arm CROSS_COMPILE=arm-linux- O=/tmp/build/ kernelrelease
3.16.0-rc3+
$

3.16-rc4:

$ make ARCH=arm CROSS_COMPILE=arm-linux- O=/tmp/build/ kernelrelease
make[1]: Entering directory `/tmp/build'
3.16.0-rc4+
$

There are tools which expect kernelrelease to only produce a single
line.  I believe c2e28dc975e (kbuild: Print the name of the build
directory) is probably responsible as this line appears on stdout.

This screws up scripts which do:

        open FH, "$build_cmd kernelrelease $O |" or die $!;
        my $kernelrelease = <FH>;
        close FH;
        chomp($kernelrelease);

or

	version=$(make O=$o kernelrelease)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
