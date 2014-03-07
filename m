Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaCGNUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:20:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaCGNUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:20:05 -0500
Date: Fri, 7 Mar 2014 14:19:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] tools, perf: Make get_srcline fall back to sym+offset
Message-ID: <20140307131957.GD13974@krava.brq.redhat.com>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393561352-23448-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:22:32PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When the source line is not found fall back to sym + offset.
> This is generally much more useful than a raw address.
> For this we need to pass in the symbol from the caller.
> For some callers it's awkward to compute, so we stay
> at the old behaviour.

could we fallback for 0 src lines as well? I'm getting following:

            |          |--99.85%-- _IO_file_xsputn@@GLIBC_2.2.5 .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0
            |          |          __GI___mempcpy .:0

also it would be handy to show raw address (object based).. maybe for -v option?

jirka
