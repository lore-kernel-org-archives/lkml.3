Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722Ab3ECQr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:47:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46091 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3ECQr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:47:58 -0400
Message-ID: <5183EA30.2000005@zytor.com>
Date: Fri, 03 May 2013 09:47:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Build-failure with old files in build-directory (Was: Linux 3.9
 released)
References: <CA+55aFxcqR+5wK0QoGBA_jYP1epH2NCbVTRaE51rLK3mdRjN6Q@mail.gmail.com> <20130429083649.GA23540@citd.de>
In-Reply-To: <20130429083649.GA23540@citd.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 01:36 AM, Matthias Schniedermeyer wrote:
> On 28.04.2013 17:56, Linus Torvalds wrote:
> 
> I'm not sure if it is supported, but building with a O= -directory that 
> was previously used to build a 3.8.9-kernel that was "clean"ed (but not 
> "mrproper"ed) before building 3.9 results in a build-failure:
> make[2]: *** No rule to make target `/xssd/usr_src/ko/leeloo/include/config/hz.h', needed by `kernel/hz.bc'.  Stop.
> 
> After deleting everything in the KBUILD_OUTPUT-directory, except the 
> .config-file, the kernel-build worked again.
> 
> At least in the past a "clean" seamed to be enough. I had a file with a 
> 2.6.39-name inside, so it seams i have build my kernels this way for the 
> last few releases.
> 

This seems to be the fundamental problem here... include/config is used
to track dependencies on configuration, but it looks like there are
events that seem to delete include/config without them being regenerated?

	-hpa


