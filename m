Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3FSNmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:42:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40929 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756427Ab3FSNmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:42:05 -0400
Message-ID: <1371649323.2038.23.camel@joe-AO722>
Subject: Re: [net] checkpatch: modify logFunction regular expression to
 allow repeated front tags
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: apw@canonical.com, Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 19 Jun 2013 06:42:03 -0700
In-Reply-To: <1371638323-20999-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1371638323-20999-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 03:38 -0700, Jeff Kirsher wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The previous logFunction regular expression allowed names for log functions like
> dev_warn or e_dbg and so forth, but some log functions are of the forms
> similar to e_dev_warn, (adding an additional tag in front of a standard name
> like dev_warn).

Perhaps names like foo_bar_baz_dev_warn are a bit long.

Maybe instead of
+	(?:[a-z0-9]+_)+(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
use
+	(?:[a-z0-9]+_){0,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|


