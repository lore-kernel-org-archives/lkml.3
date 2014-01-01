Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaAAUEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 15:04:31 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50490 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaAAUEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 15:04:30 -0500
Message-ID: <52C474CB.8000300@gmail.com>
Date: Wed, 01 Jan 2014 15:04:27 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Shea Levy <shea@shealevy.com>, linux-kernel@vger.kernel.org
Subject: Re: Build and Source Tree Requirements for Out-of-tree Modules
References: <52C43027.7010702@shealevy.com>
In-Reply-To: <52C43027.7010702@shealevy.com>
X-Enigmail-Version: 1.6
OpenPGP: id=85D2EC0F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2014 10:11 AM, Shea Levy wrote:
> Hi all,
> 
> I am a package maintainer for the kernel for the NixOS
> distribution. We support users building out-of-tree modules and
> other packages that might depend on the kernel source or build
> trees, but make modules_install copies the entire source and build
> trees (we build with $(O) set) to $(INSTALL_PATH), and those are
> some big paths to keep around. Is there any documentation on which
> of those files should actually be needed by any out-of-tree tools?
> For example I'm guessing the intermediate object files in the build
> tree or the .c files in the source tree are not necessary, but it
> would be nice if there were a definitive list of what could be
> removed to save space.
Running 'make modules_prepare' in a clean source tree should set up
the sources with everything needed for out of tree modules, it largely
amounts to the .config file, a few scripts, and a couple of specific
other files.

