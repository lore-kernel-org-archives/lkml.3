Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaGKQpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:45:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaGKQpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:45:01 -0400
Message-ID: <53C01484.8080609@zytor.com>
Date: Fri, 11 Jul 2014 09:44:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
CC: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32
 filter
References: <cover.1405023592.git.rgb@redhat.com> <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com> <8897229.50V8e7SIxg@sifl>
In-Reply-To: <8897229.50V8e7SIxg@sifl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 09:36 AM, Paul Moore wrote:
> 
> Arguably audit is broken anyway by not correctly treating syscall numbers as 
> 32 bit integers like everyone else.
> 

That is really the root cause of the problem.  x86 is not the only
architecture with a sparse syscall numbering scheme (in fact the x32
method was based on the MIPS syscall numbering scheme.)

What syscall_get_nr() returns becomes a matter of definition at that point.

	-hpa

