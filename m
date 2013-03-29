Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3C2JM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:12:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab3C2JM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:12:27 -0400
Message-ID: <51555AF9.4020009@suse.cz>
Date: Fri, 29 Mar 2013 10:12:25 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][update] Makefile: allow no update .config build
References: <1364517997-24067-1-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1364517997-24067-1-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.3.2013 01:46, liguang wrote:
> if we pull some commits from other git repo
> which bring in a few CONFIG_* options, then
> we have to build all again, but we do assure
> these options are not interesting for us,
> so the long waiting build will be offending.
> this change help us to avoid all-build.

scripts/basic/fixdep makes sure that only the affected parts are rebuild
when the config changes. Obviously, if a CONFIG_ option appears in a
widely used header file, the whole kernel is rebuilt. Otherwise object
files would be built with different versions of the header file. If you
want to shoot yourself in the foot and override this, then do a 'touch
include/config/*.conf', but please do not add such a hack to the Makefile.

Michal
