Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbbANI7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:59:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:28212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbANI7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:59:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,754,1413270000"; 
   d="scan'208";a="637070130"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Moore, Robert" <robert.moore@intel.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] acpica: utpredef: Remove some unused functions
Thread-Topic: [PATCH] acpica: utpredef: Remove some unused functions
Thread-Index: AQHQKDHsN5zpZL4nm0KX8o7V77Osx5y/Xsfw
Date: Wed, 14 Jan 2015 08:55:49 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026B7475@SHSMSX101.ccr.corp.intel.com>
References: <1420384974-11745-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420384974-11745-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rickard

The functions below seem already marked by "ACPI_ASL_COMPILER || ACPI_HELP_APP".
How did you detect them as used functions?

Thanks
-Lv


> -----Original Message-----
> From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
> Sent: Sunday, January 04, 2015 11:23 PM
> To: Moore, Robert; Zheng, Lv
> Cc: Rickard Strandqvist; Wysocki, Rafael J; Len Brown; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] acpica: utpredef: Remove some unused functions
> 
> Removes some functions that are not used anywhere:
> acpi_ut_get_resource_bit_width() acpi_ut_display_predefined_method() acpi_ut_match_resource_name()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/acpi/acpica/acutils.h  |    9 ---
>  drivers/acpi/acpica/utpredef.c |  134 ----------------------------------------
>  2 files changed, 143 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
> index 486d342..9b3fab1 100644
> --- a/drivers/acpi/acpica/acutils.h
> +++ b/drivers/acpi/acpica/acutils.h
> @@ -502,17 +502,8 @@ const union acpi_predefined_info *acpi_ut_get_next_predefined_method(const union
> 
>  const union acpi_predefined_info *acpi_ut_match_predefined_method(char *name);
> 
> -const union acpi_predefined_info *acpi_ut_match_resource_name(char *name);
> -
> -void
> -acpi_ut_display_predefined_method(char *buffer,
> -				  const union acpi_predefined_info *this_name,
> -				  u8 multi_line);
> -
>  void acpi_ut_get_expected_return_types(char *buffer, u32 expected_btypes);
> 
> -u32 acpi_ut_get_resource_bit_width(char *buffer, u16 types);
> -
>  /*
>   * utstate - Generic state creation/cache routines
>   */
> diff --git a/drivers/acpi/acpica/utpredef.c b/drivers/acpi/acpica/utpredef.c
> index db30caf..f1ff33c 100644
> --- a/drivers/acpi/acpica/utpredef.c
> +++ b/drivers/acpi/acpica/utpredef.c
> @@ -209,105 +209,6 @@ static const char *ut_resource_type_names[] = {
> 
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_ut_match_resource_name
> - *
> - * PARAMETERS:  name                - Name to find
> - *
> - * RETURN:      Pointer to entry in the resource table. NULL indicates not
> - *              found.
> - *
> - * DESCRIPTION: Check an object name against the predefined resource
> - *              descriptor object list.
> - *
> - ******************************************************************************/
> -
> -const union acpi_predefined_info *acpi_ut_match_resource_name(char *name)
> -{
> -	const union acpi_predefined_info *this_name;
> -
> -	/* Quick check for a predefined name, first character must be underscore */
> -
> -	if (name[0] != '_') {
> -		return (NULL);
> -	}
> -
> -	/* Search info table for a predefined method/object name */
> -
> -	this_name = acpi_gbl_resource_names;
> -	while (this_name->info.name[0]) {
> -		if (ACPI_COMPARE_NAME(name, this_name->info.name)) {
> -			return (this_name);
> -		}
> -
> -		this_name++;
> -	}
> -
> -	return (NULL);		/* Not found */
> -}
> -
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_ut_display_predefined_method
> - *
> - * PARAMETERS:  buffer              - Scratch buffer for this function
> - *              this_name           - Entry in the predefined method/name table
> - *              multi_line          - TRUE if output should be on >1 line
> - *
> - * RETURN:      None
> - *
> - * DESCRIPTION: Display information about a predefined method. Number and
> - *              type of the input arguments, and expected type(s) for the
> - *              return value, if any.
> - *
> - ******************************************************************************/
> -
> -void
> -acpi_ut_display_predefined_method(char *buffer,
> -				  const union acpi_predefined_info *this_name,
> -				  u8 multi_line)
> -{
> -	u32 arg_count;
> -
> -	/*
> -	 * Get the argument count and the string buffer
> -	 * containing all argument types
> -	 */
> -	arg_count = acpi_ut_get_argument_types(buffer,
> -					       this_name->info.argument_list);
> -
> -	if (multi_line) {
> -		printf("      ");
> -	}
> -
> -	printf("%4.4s    Requires %s%u argument%s",
> -	       this_name->info.name,
> -	       (this_name->info.argument_list & ARG_COUNT_IS_MINIMUM) ?
> -	       "(at least) " : "", arg_count, arg_count != 1 ? "s" : "");
> -
> -	/* Display the types for any arguments */
> -
> -	if (arg_count > 0) {
> -		printf(" (%s)", buffer);
> -	}
> -
> -	if (multi_line) {
> -		printf("\n    ");
> -	}
> -
> -	/* Get the return value type(s) allowed */
> -
> -	if (this_name->info.expected_btypes) {
> -		acpi_ut_get_expected_return_types(buffer,
> -						  this_name->info.
> -						  expected_btypes);
> -		printf("  Return value types: %s\n", buffer);
> -	} else {
> -		printf("  No return value\n");
> -	}
> -}
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_ut_get_argument_types
>   *
>   * PARAMETERS:  buffer              - Where to return the formatted types
> @@ -361,39 +262,4 @@ static u32 acpi_ut_get_argument_types(char *buffer, u16 argument_types)
>  	return (arg_count);
>  }
> 
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_ut_get_resource_bit_width
> - *
> - * PARAMETERS:  buffer              - Where the formatted string is returned
> - *              types               - Bitfield of expected data types
> - *
> - * RETURN:      Count of return types. Formatted string in Buffer.
> - *
> - * DESCRIPTION: Format the resource bit widths into a printable string.
> - *
> - ******************************************************************************/
> -
> -u32 acpi_ut_get_resource_bit_width(char *buffer, u16 types)
> -{
> -	u32 i;
> -	u16 sub_index;
> -	u32 found;
> -
> -	*buffer = 0;
> -	sub_index = 1;
> -	found = 0;
> -
> -	for (i = 0; i < NUM_RESOURCE_WIDTHS; i++) {
> -		if (types & 1) {
> -			strcat(buffer, &(ut_resource_type_names[i][sub_index]));
> -			sub_index = 0;
> -			found++;
> -		}
> -
> -		types >>= 1;
> -	}
> -
> -	return (found);
> -}
>  #endif
> --
> 1.7.10.4

