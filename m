Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3BUVOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:14:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab3BUVOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:14:21 -0500
Message-ID: <51268E25.6070104@suse.cz>
Date: Thu, 21 Feb 2013 22:14:13 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Unset LANG in setlocalversion script
References: <201302211249.r1LCno6O024776@localhost.localdomain>
In-Reply-To: <201302211249.r1LCno6O024776@localhost.localdomain>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 21.2.2013 13:49, Christophe Leroy napsal(a):
> This patch allows the use of setlocalversion script regardless of the LANG
> parameter. Otherwise, the `svn info 2>/dev/null | grep '^Last Changed Rev'`
> returns nothing because for instance, in French the text 'Last Changed Rev'
> is replaced by 'Révision de la dernière modification'

Unsetting LANG might not be enough. You should unset LC_ALL and set
LC_MESSAGES=C. But - is this a problem for other commands in the script?
>From a quick look, we only parse English output of svn, so I suggest to
only set the env var for the svn command.

Michal
