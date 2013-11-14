Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3KNDWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 22:22:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45033 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3KNDWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 22:22:31 -0500
Message-ID: <1384399344.2312.6.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 0/4] ima: add support for custom template formats
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, zohar@us.ibm.com,
        d.kasatkin@samsung.com, james.l.morris@oracle.com
Date: Wed, 13 Nov 2013 22:22:24 -0500
In-Reply-To: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
References: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111403-8236-0000-0000-000003C71B76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 15:00 +0100, Roberto Sassu wrote:
> Hi everyone
> 
> currently accepted patches for the new template management mechanism allow to
> choose among a list of supported templates, statically defined in the code.
> This functionality is not flexible enough as users may want to include
> in their measurements list only information needed and not use predefined
> combinations.
> 
> For this reason, this patch set introduce the new kernel command line parameter
> 'ima_template_fmt' to specify a custom template format at boot time,
> i.e. a string of template fields identifiers concatenated with the '|'
> separator character. The complete list of defined template fields can be
> found in Documentation/security/IMA-templates.txt.
> 
> The format string is checked at the very beginning in the setup function
> ima_template_fmt_setup() so that, if it is wrong, IMA can go back to the
> default template, selected through a kernel configuration option.
> 
> To allow userspace tools parse a measurements list with a custom format, IMA
> provides as template name the same format string provided by users at boot
> time, so that tools know which information are included in a entry and extract
> them if they can handle listed template fields.
> 
> Roberto Sassu

Cool, this is a really nice patchset!

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

> 
> Roberto Sassu (4):
>   ima: added error messages to template-related functions
>   ima: make a copy of template_fmt in template_desc_init_fields()
>   ima: display template format in meas. list if template name length is
>     zero
>   ima: added support for new kernel cmdline parameter ima_template_fmt
> 
>  Documentation/kernel-parameters.txt      |  4 ++
>  Documentation/security/IMA-templates.txt | 29 +++++++------
>  security/integrity/ima/ima_fs.c          | 18 ++++++--
>  security/integrity/ima/ima_template.c    | 71 ++++++++++++++++++++++++++++++--
>  4 files changed, 100 insertions(+), 22 deletions(-)
> 


