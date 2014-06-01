Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaFAK7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 06:59:35 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38841 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbaFAK7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:59:33 -0400
Date: Sun, 1 Jun 2014 13:59:27 +0300
From: Muli Ben-Yehuda <mulix@mulix.org>
To: Jun Koi <junkoi2004@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Nested KVM is weird?
Message-ID: <20140601105927.GD2385@needle>
References: <CA+g7VZ3kFEGjeiQLnoK4GFAYU4=Y-4HU1gzz15A-sCO406qekQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+g7VZ3kFEGjeiQLnoK4GFAYU4=Y-4HU1gzz15A-sCO406qekQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 05:54:25PM +0700, Jun Koi wrote:

> So this means ESXi never uses VMResume/VMLaunch? How is this
> possible, because it uses VMX for its implementation?

ESXi will fall back to binary translation if it decides that it cannot
use VMX for some reason. Look at the L2's log file inside ESXi and you
will likely find some errors related to running nested, MSRs KVM does
not emulate properly, or something else that causes ESXi to use binary
translation for its L2.

Cheers,
Muli
