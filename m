Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3IYPYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:24:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36546 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3IYPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:24:38 -0400
Date: Wed, 25 Sep 2013 16:24:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-ID: <20130925152432.GY13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380047934.3575.100.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 11:38:54AM -0700, Joe Perches wrote:
> Checkpatch doesn't currently find CamelCase definitions
> of structs, unions or enums.
> 
> Add that ability.

Fix your regex.  As it is, it catches the things that are not camelcase
by any stretch of definition - [A-Z][a-z]+ will get caught by that and
it's neither camelcase nor something that ought to be discouraged for
e.g. enum member names.

CamelCase refers to caps in the middle of a compound, used to visually
separate them.
