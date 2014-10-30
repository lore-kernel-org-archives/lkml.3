Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbaJ3RZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:25:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469AbaJ3RZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:25:28 -0400
Message-ID: <54527443.6030007@zytor.com>
Date: Thu, 30 Oct 2014 10:24:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
CC: Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, jbaron@akamai.com,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] kernel, add panic_on_warn
References: <1414688627-5298-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1414688627-5298-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 10:03 AM, Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 
> A much easier method would be a switch to change the WARN() over to a
> panic.  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
> 
> This patch adds a panic_on_warn kernel parameter and
> /proc/sys/kernel/panic_on_warn calls panic() in the warn_slowpath_common()
> path.  The function will still print out the location of the warning.
> 
> An example of the panic_on_warn output:
> 
> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
> After that the panic() output is displayed.
> 

There is another very valid use for this: many operators would rather a
machine shuts down than being potentially compromised either
functionally or security-wise.

	-hpa


