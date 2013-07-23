Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3GWMuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:50:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab3GWMt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:49:59 -0400
Message-ID: <51EE7BF3.4020301@suse.cz>
Date: Tue, 23 Jul 2013 14:49:55 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem using gtags target
References: <9hhtxk5nf05.fsf@arm.com>
In-Reply-To: <9hhtxk5nf05.fsf@arm.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.7.2013 19:22, Punit Agrawal wrote:
> Hi,
> 
> I am trying to use GNU global for kernel source browsing but have run
> into a problem when using "gtags" target in Makefile. The index
> files(GTAGS, GSYMS, GPATH, GRTAGS) don't work and on further
> investigation turned out to be 16kb each in size. My command line is - 
> 
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j5 gtags

So you have a command that fails

> 
> On some digging, I traced the relevant code to scripts/tags.sh which
> produces reasonably sized indices (modulo some  missing environment
> variables) when run as - 
> 
> ./scripts/tags.sh gtags

...and a command that works. So you can start "bisecting" between these
two: Try removing -j5 or ARCH= or  CROSS_COMPILE= from the make command
line. Still failing? Add 'printenv >env.make' to the tags.sh script and
run it via make tags. Compare the env.make file with printenv output
from the shell. Try setting the variables from env.make in the shell and
see when ./scripts/tags.sh gtags starts failing.

FWIW, both your commands seem to work for me and produce a GRTAGS that
is 256MB big.

Michal
