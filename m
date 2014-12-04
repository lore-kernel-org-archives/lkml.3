Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaLDQ4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:56:37 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13476 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932655AbaLDQ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:56:35 -0500
Message-ID: <5480923D.5010503@sonymobile.com>
Date: Thu, 4 Dec 2014 08:56:29 -0800
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Shuah Khan <shuahkh@osg.samsung.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RFC: kselftest size roadmap
References: <547F598D.7030205@sonymobile.com> <20141204003653.GA5004@thin>
In-Reply-To: <20141204003653.GA5004@thin>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an RFC on my roadmap for the kselftest size test going forward...

In the long term, I'd like to be able to use the test for bisecting
size regressions, and to allow any kernel developer to use this even if they
don't have hardware for a particular architecture.

What I'd like to add to this in the future:
 - cleaned up approach to cross-compilation
   - put CROSS_COMPILE handling outside sub-directory Makefiles
   - this should include support for KBUILD_OUTPUT
   - handle CFLAGS for user-space programs (as opposed to
     kernel CFLAGS), and in a unified way

 - ability to run on target or in emulator
   - will involve adding an "install phase", and 
   possibly a "collect results" phase.  These are needed
   throughout kselftest to do any host/target 
   testing.

 - add a size threshold parameter to allow the
  test to check for a regression
   - test needs to return failure code that git
    bisect can use (not sure about mechanism for this yet)
   - regression test might utilize a feature to save off a
   "baseline" size to measure against, for the ability 
   to indicate a regression as "current size > baseline + 20k"

Any feedback on this?

Thanks,
 -- Tim
