Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaGKQLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbaGKQLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:11:42 -0400
From: Paul Moore <pmoore@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
Date: Fri, 11 Jul 2014 12:11:37 -0400
Message-ID: <1458762.ra4TnS54ZN@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <53BF62AA.20105@zytor.com>
References: <cover.1405023592.git.rgb@redhat.com> <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com> <53BF62AA.20105@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 10, 2014 09:06:02 PM H. Peter Anvin wrote:
> Incidentally: do seccomp users know that on an x86-64 system you can
> recevie system calls from any of the x86 architectures, regardless of
> how the program is invoked?  (This is unusual, so normally denying those
> "alien" calls is the right thing to do.)

I obviously can't speak for all seccomp users, but libseccomp handles this by 
checking the seccomp_data->arch value at the start of the filter and killing 
(by default) any non-native architectures.  If you want, you can change this 
default behavior or add support for other architectures (e.g. create a filter 
that allows both x86-64 and x32 but disallows x86, or any combination of the 
three for that matter).

-- 
paul moore
security and virtualization @ redhat

